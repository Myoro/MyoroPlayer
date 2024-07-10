import 'package:flutter/foundation.dart';
import 'package:frontend/shared/helpers/platform_helper.dart';
import 'package:frontend/shared/models/conditions.dart';
import 'package:frontend/shared/models/playlist.dart';
import 'package:frontend/shared/models/song.dart';
import 'package:frontend/shared/models/user_preferences.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart' as sqflite;
import 'package:sqflite_common_ffi/sqflite_ffi.dart';

/// The local database
///
/// A singleton that needs to be initialized with [Database.init()]
final class Database {
  static const userPreferencesTableName = 'user_preferences';
  static const playlistsTableName = 'playlists';
  static const songsTableName = 'songs';

  sqflite.Database? _database;

  Future<String> _getDatabasePath() async {
    return join(
      (await getApplicationCacheDirectory()).path,
      'myoro_player.db',
    );
  }

  /// Initializes the database
  Future<void> init() async {
    if (_database != null) {
      if (kDebugMode) {
        print('[Database.init]: Database already initialized.');
      }
    }

    if (PlatformHelper.isDesktop) {
      sqflite.databaseFactory = databaseFactoryFfi;
    }

    _database = await sqflite.openDatabase(await _getDatabasePath());

    // User preferences table
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

    // Playlists table
    await _database?.execute('''
      CREATE TABLE IF NOT EXISTS $playlistsTableName(
        ${Playlist.idJsonKey} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Playlist.pathJsonKey} TEXT,
        ${Playlist.nameJsonKey} TEXT,
        ${Playlist.imageJsonKey} LONGTEXT
      );
    ''');

    // Songs table
    await _database?.execute('''
      CREATE TABLE IF NOT EXISTS $songsTableName(
        ${Song.idJsonKey} INTEGER PRIMARY KEY AUTOINCREMENT,
        ${Song.pathJsonKey} TEXT,
        ${Song.coverJsonKey} BLOB,
        ${Song.titleJsonKey} TEXT,
        ${Song.artistJsonKey} TEXT,
        ${Song.albumJsonKey} TEXT,
        ${Song.durationJsonKey} INTEGER,
        ${Song.playlistIdJsonKey} INTEGER,
        FOREIGN KEY (${Song.playlistIdJsonKey}) REFERENCES $playlistsTableName(${Playlist.idJsonKey}) ON DELETE CASCADE
      );
    ''');
  }

  /// Only for debugging
  Future<void> deleteThenInit() async {
    await init();
    sqflite.deleteDatabase(await _getDatabasePath());
    await init();
  }

  /// Closes the database
  Future<void> close() async => _database?.close();

  /// SQL select query
  Future<List<Map<String, dynamic>>> select(
    String table, {
    Conditions? conditions,
  }) async {
    try {
      return await _database!.query(
        table,
        where: conditions?.where,
        whereArgs: conditions?.whereArgs,
      );
    } catch (error) {
      if (kDebugMode) {
        print('[Database.select]: Error selecting.');
      }

      return [];
    }
  }

  /// SQL get query, returns the first item of a select query
  Future<Map<String, dynamic>?> get(String table, {Conditions? conditions}) async {
    final rows = await select(table, conditions: conditions);
    return rows.isEmpty ? null : rows.first;
  }

  /// Returns the ID of the newly created item if successful, null if not successful
  Future<int?> insert(
    String table, {
    required Map<String, dynamic> data,
  }) async {
    try {
      return await _database?.insert(table, data);
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('[Database.insert]: Error inserting: "$error"');
        print('Stack trace:\n$stackTrace');
      }

      return null;
    }
  }

  /// Returns if the operation was successful or not
  Future<bool> update(
    String table, {
    required Map<String, dynamic> data,
    Conditions? conditions,
  }) async {
    try {
      await _database?.update(
        table,
        data,
        where: conditions?.where,
        whereArgs: conditions?.whereArgs,
      );

      return true;
    } catch (error) {
      if (kDebugMode) {
        print('[Database.update]: Error updating.');
      }

      return false;
    }
  }

  /// Returns if the operation was successful or not
  Future<bool> delete(String table, {required int id}) async {
    try {
      await _database?.delete(table, where: 'id = ?', whereArgs: [id]);
      return true;
    } catch (error) {
      if (kDebugMode) {
        print('[Database.delete]: Error removing row from table.');
      }
      return false;
    }
  }

  /// Only for debugging
  Future<void> createPopulatedDummyTable() async {
    await sqflite.deleteDatabase(await _getDatabasePath());
    await init();

    await _database?.execute('''
      CREATE TABLE IF NOT EXISTS foo(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        data INTEGER
      );
    ''');

    for (int i = 0; i < 10; i++) {
      await insert('foo', data: {'data': i + 1});
    }
  }
}
