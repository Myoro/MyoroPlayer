import 'package:flutter/foundation.dart';
import 'package:myoro_player/shared/models/user_preferences.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// The local database
///
/// A singleton that needs to be initialized with [Database.init()]
final class Database {
  static const userPreferencesTableName = 'user_preferences';

  sqflite.Database? _database;

  Future<void> init() async {
    if (_database != null) {
      if (kDebugMode) {
        print('[Database.init]: Database already initialized.');
      }
    }

    sqflite.databaseFactory = databaseFactoryFfi;

    final dbPath = await getApplicationCacheDirectory();
    _database =
        await sqflite.openDatabase(join(dbPath.path, 'myoro_player.db'));

    await _database?.execute('''
      CREATE TABLE IF NOT EXISTS $userPreferencesTableName(
        id INTEGER PRIMARY KEY,
        ${UserPreferences.darkModeJsonKey} INTEGER
      );
    ''');
    if (await get(userPreferencesTableName) == null) {
      await insert(
        userPreferencesTableName,
        data: {UserPreferences.darkModeJsonKey: 1},
      );
    }
  }

  Future<List<Map<String, dynamic>>> select(String table,
      {Map<String, dynamic>? conditions}) async {
    // TODO: Format conditions
    if (_database == null) {
      if (kDebugMode) {
        print('[Database.select]: Database not initialized.');
      }
    }

    return await _database!.query(table);
  }

  Future<Map<String, dynamic>?> get(String table,
      {Map<String, dynamic>? conditions}) async {
    final rows = await select(table, conditions: conditions);
    return rows.isEmpty ? null : rows.first;
  }

  /// Returns the ID of the newly created item if successful, null if not successful
  Future<int?> insert(
    String table, {
    required Map<String, dynamic> data,
    Map<String, dynamic>? conditions,
  }) async {
    // TODO: Format conditions
    return await _database?.insert(table, data);
  }

  /// Returns if the operation was successful or not
  Future<bool> update(
    String table, {
    required Map<String, dynamic> data,
    Map<String, dynamic>? conditions,
  }) async {
    // TODO: Format conditions
    try {
      await _database?.update(table, data);
      return true;
    } catch (error) {
      if (kDebugMode) {
        print('[Database.update]: Error updating.');
      }

      return false;
    }
  }
}
