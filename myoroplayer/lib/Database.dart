import "dart:io";
import "package:flutter/foundation.dart";
import "package:sqflite/sqflite.dart" as sqflite;
import "package:sqflite_common_ffi/sqflite_ffi.dart";
import "package:path/path.dart";
import "package:path_provider/path_provider.dart";

class Database {
  late sqflite.Database _database;
  final VoidCallback initialized;

  Database({ required this.initialized }) { init(); }

  void init() async {
    if(!kIsWeb && (Platform.isWindows || Platform.isMacOS || Platform.isLinux)) {
      sqfliteFfiInit();
      sqflite.databaseFactory = databaseFactoryFfi;
    }

    final documentsDirectory = await getApplicationDocumentsDirectory();
    _database = await sqflite.openDatabase(join(documentsDirectory.path, "myoroplayer.db"));
    await _database?.rawQuery("CREATE TABLE IF NOT EXISTS dark_mode(id INTEGER PRIMARY KEY, enabled TEXT);");
    await _database?.insert("dark_mode", { "enabled": "0" });

    // Allows State to set darkMode
    initialized();
  }

  Future<bool> getDarkMode() async {
    final row = await _database.rawQuery("SELECT enabled FROM dark_mode;");
    return row[0]["enabled"] == '0' ? false : true;
  }

  void setDarkMode(value) => _database.update("dark_mode", { "enabled": value ? '1' : '0' });
}
