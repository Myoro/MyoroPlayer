import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/database.dart';
import 'package:frontend/shared/models/conditions.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  final database = Database();

  setUpAll(() async {
    TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger.setMockMethodCallHandler(
      const MethodChannel('plugins.flutter.io/path_provider'),
      (_) async => './',
    );

    await database.init();
    await database.createPopulatedDummyTable();
  });

  tearDownAll(() async => await database.close());

  test('Database.select', () async {
    // Conditionless query
    expect(
      await database.select('foo'),
      List.generate(
        10,
        (index) {
          return {
            'id': index + 1,
            'data': index + 1,
          };
        },
      ),
    );

    // Query with conditions
    expect(
      await database.select('foo', conditions: Conditions(const {'data': 5})),
      [
        {'id': 5, 'data': 5},
      ],
    );

    // Non-existent row query
    expect(
      await database.select('foo', conditions: Conditions(const {'data': 0})),
      isEmpty,
    );

    // Syntactically incorrect query
    expect(
      await database.select('oqoijeoqijwe', conditions: Conditions(const {})),
      isEmpty,
    );
  });

  test('Database.get', () async {
    // Conditionless query
    expect(
      await database.get('foo'),
      {'id': 1, 'data': 1},
    );

    // Query with conditions
    expect(
      await database.get('foo', conditions: Conditions(const {'data': 2})),
      {'id': 2, 'data': 2},
    );

    // Non-existent row query
    expect(
      await database.get('foo', conditions: Conditions(const {'data': 100})),
      isNull,
    );

    // Syntactically incorrect query
    expect(
      await database.get('qiwjeoiqjweoij', conditions: Conditions(const {})),
      isNull,
    );
  });

  test('Database.insert', () async {
    expect((await database.select('foo')).length, 10);

    // Passing case
    final int? id = await database.insert('foo', data: {'data': 11});
    final rows = await database.select('foo');
    expect(rows.length, 11);
    expect(rows.last, {'id': id, 'data': 11});

    // Incorrect syntax/failure case
    expect(
      await database.insert('oijqwoeijqwe', data: {}),
      isNull,
    );
  });

  test('Database.update', () async {
    // Passing case with conditions
    expect(
      await database.update(
        'foo',
        data: {'data': 100},
        conditions: Conditions(const {'id': 5}),
      ),
      isTrue,
    );
    expect(
      await database.get('foo', conditions: Conditions(const {'id': 5})),
      {'id': 5, 'data': 100},
    );
    expect(
      // Confirming we didn't change everything
      await database.get('foo', conditions: Conditions(const {'id': 6})),
      {'id': 6, 'data': 6},
    );

    // Passing case without conditions (changes the entire table)
    expect(
      await database.update('foo', data: {'data': 9001}),
      isTrue,
    );
    expect(
      await database.select('foo'),
      List.generate(
        11,
        (index) {
          return {
            'id': index + 1,
            'data': 9001,
          };
        },
      ),
    );

    // Incorrect syntax/failure case
    expect(
      await database.update('foqowijeq', data: {}, conditions: Conditions(const {})),
      isFalse,
    );
  });

  test('Database.delete', () async {
    // Successfully removing all of the rows from the dummy table
    for (int i = 0; i < 11; i++) {
      expect(await database.delete('foo', id: i + 1), isTrue);
    }
    expect(await database.select('foo'), isEmpty);

    // Incorrect syntax case
    expect(await database.delete('qwioejqoije', id: 500), isFalse);
  });
}
