import 'package:myoro_player/helpers/platform_helper.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

class Database {
  static late final sqflite.Database _database;

  static Future<String> getDatabasePath() async => join(
        (await getApplicationSupportDirectory()).path,
        'myoro_player.db',
      );

  /// When the [condition] argument of any [Database] function is provided, it will be in the format:
  /// { <Database Attribute>: <Database Attribute Value> }
  ///
  /// This function will turn this format into [where] & [whereArgs] for SQLite
  /// [where]'s format: '<Database Attribute> = ? AND <Database Attribute> ...`
  /// [whereArgs]'s format: [<Database Attribute Value>, <Database Attribute Value>, ...]
  static Map<String, dynamic>? formatConditions(
      Map<String, Object?>? conditions) {
    if (conditions == null) return null;

    final List<MapEntry> conditionsList = conditions.entries.toList();
    String where = '';
    final List<Object?> whereArgs = [];
    for (final MapEntry entry in conditionsList) {
      where +=
          '${entry.key} = ?${conditionsList.indexOf(entry) != conditionsList.length - 1 ? ' AND ' : ''}';
      whereArgs.add(entry.value);
    }

    return {'where': where, 'whereArgs': whereArgs};
  }

  static Future<void> init() async {
    if (PlatformHelper.isDesktop) sqflite.databaseFactory = databaseFactoryFfi;
    _database = await sqflite.openDatabase(await getDatabasePath());

    // Dark mode table
    await _database.execute('''
      CREATE TABLE IF NOT EXISTS dark_mode(
        id INTEGER PRIMARY KEY,
        enabled INTEGER
      );
    ''');
    if ((await get('dark_mode')).isEmpty) insert('dark_mode', {'enabled': 1});
  }

  static Future<void> reset() async {
    await sqflite.deleteDatabase(await getDatabasePath());
    await _database.close();
    await init();
  }

  static Future<List<Map<String, Object?>>> select(String table,
      [Map<String, dynamic>? conditions]) async {
    conditions = formatConditions(conditions);

    return await _database.query(
      table,
      where: conditions?['where'],
      whereArgs: conditions?['whereArgs'],
    );
  }

  static Future<Map<String, Object?>> get(String table,
      [Map<String, dynamic>? conditions]) async {
    final List<Map<String, Object?>> rows = await select(table, conditions);
    return rows.isEmpty ? {} : rows[0];
  }

  /// Returns the id of the new item
  static Future<int> insert(String table, Map<String, dynamic> data) async =>
      await _database.insert(table, data);

  static Future<void> update(String table, Map<String, dynamic> data,
      [Map<String, dynamic>? conditions]) async {
    conditions = formatConditions(conditions);

    await _database.update(
      table,
      data,
      where: conditions?['where'],
      whereArgs: conditions?['whereArgs'],
    );
  }

  static Future<void> delete(String table,
      [Map<String, dynamic>? conditions]) async {
    conditions = formatConditions(conditions);

    await _database.delete(
      table,
      where: conditions?['where'],
      whereArgs: conditions?['whereArgs'],
    );
  }
}
