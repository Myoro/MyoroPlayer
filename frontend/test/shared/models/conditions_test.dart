import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/models/conditions.dart';

void main() {
  test('Conditions when given an empty JSON case', () {
    final conditions = Conditions(const {});
    expect(conditions.where, isEmpty);
    expect(conditions.whereArgs, isEmpty);
  });

  test('Conditions when given a one key JSON case', () {
    final conditions = Conditions(const {'foo': 'foofoo'});
    expect(conditions.where, 'foo = ?');
    expect(conditions.whereArgs, ['foofoo']);
  });

  test('Conditions when given a multi-key JSON case', () {
    final conditions = Conditions(const {'foo': 'foofoo', 'qwe': 'qweqwe'});
    expect(conditions.where, 'foo = ? AND qwe = ?');
    expect(conditions.whereArgs, ['foofoo', 'qweqwe']);
  });

  test('Conditions.toString', () {
    final conditions = Conditions(const {});
    expect(
      conditions.toString(),
      'Conditions(\n'
      '  where: ${conditions.where},\n'
      '  whereArgs: ${conditions.whereArgs},\n'
      ');',
    );
  });

  test('Conditions.props', () {
    final conditions = Conditions(const {});
    final conditionsCopy = Conditions(const {});
    final conditionsUnique = Conditions(const {'foo': 'foofoo'});
    expect(conditions == conditionsCopy, isTrue);
    expect(conditions == conditionsUnique, isFalse);
  });
}
