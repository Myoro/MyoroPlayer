// coverage:ignore-file

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:myoro_player/core/database.dart';
import 'package:myoro_player/core/extensions/string_extension.dart';
import 'package:myoro_player/core/helpers/platform_helper.dart';
import 'package:myoro_player/core/models/conditions.dart';
import 'package:myoro_player/core/models/playlist.dart';
import 'package:myoro_player/core/models/song.dart';
import 'package:id3tag/id3tag.dart';
import 'package:mp3_info/mp3_info.dart';
import 'package:path/path.dart';

/// Used for any operation regarding the file system
///
/// i.e. File/folder dialog menus, writing files, etc...
class FileSystemHelper {
  final Database database;

  const FileSystemHelper(this.database);

  /// Returns the path to the folder in which the user wants to create, null if cancelled
  Future<String?> createFolderDialogWindow() async {
    return await FilePicker.platform.saveFile(
      dialogTitle: 'Choose the location of your new playlist',
    );
  }

  /// Returns the path to the folder in which the user wants to add, null if cancelled
  Future<String?> openFolderDialogWindow({required String title}) async {
    return await FilePicker.platform.getDirectoryPath(
      dialogTitle: title,
    );
  }

  Future<String?> openImageDialogWindow() async {
    return (await FilePicker.platform.pickFiles(
      dialogTitle: 'Select an image (PNG, JPG, or JPEG)',
      type: FileType.image,
      allowMultiple: false,
    ))
        ?.files
        .first
        .path;
  }

  /// Creates a folder on the device. Returns if the operation was successful or not
  bool createFolder(String path) {
    try {
      Directory(path).createSync();

      return true;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('[FileSystemHelper.createFolder]: Error creating folder: "$error".');
        print('Stack trace:\n$stackTrace');
      }

      return false;
    }
  }

  /// Returns if the new path if the operation was successful
  String? renameFolder(String path, String newName) {
    try {
      final newFolder = Directory(path).renameSync(
        join(
          path.substring(
            0,
            path.indexOf(
              path.split(PlatformHelper.slash).last,
            ),
          ),
          newName,
        ),
      );

      return newFolder.path;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('[FileSystemHelper.renameFolder]: Error renaming folder: "$error".');
        print('Stack trace:\n$stackTrace');
      }

      return null;
    }
  }

  /// Returns if the operation was successful
  bool deleteFolder(String path) {
    try {
      Directory(path).deleteSync(recursive: true);
      return true;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('[FileSystemHelper.deleteFolder]: Error deleting folder: "$error"');
        print('Stack trace:\n$stackTrace');
      }

      return false;
    }
  }

  /// Returns the path of the new file path if successful
  String? copyFile(String filePath, String newFolderPath) {
    try {
      final newFilePath = join(newFolderPath, filePath.pathName);
      File(filePath).copySync(newFilePath);
      return newFilePath;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('[FileSystemHelper.copyFile]: Error copying file: "$error".');
        print('Stack trace:\n$stackTrace');
      }

      return null;
    }
  }

  /// Returns the path of the new file path is successful
  String? moveFile(String filePath, String newFolderPath) {
    try {
      final newFilePath = join(newFolderPath, filePath.pathName);
      File(filePath).renameSync(newFilePath);
      return newFilePath;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('[FileSystemHelper.moveFile]: Error moving file: "$error".');
        print('Stack trace:\n$stackTrace');
      }
      return null;
    }
  }

  /// Returns if the operation was successful
  bool deleteFile(String filePath) {
    try {
      File(filePath).deleteSync();
      return true;
    } catch (error, stackTrace) {
      if (kDebugMode) {
        print('[FileSystemHelper.deleteFile]: Error deleting file: "$error".');
        print('Stack trace:\n$stackTrace');
      }
      return false;
    }
  }

  /// Returns the list of MP3 files extracted from a [Playlist]
  Future<List<Song>> getMp3FilesFromFolder(Playlist playlist) async {
    final folder = Directory(playlist.path);

    // Making sure that [path] is a valid folder
    if (!folder.existsSync()) {
      if (kDebugMode) {
        print('[FileSystemHelper.getMp3FilesFromFolder]: Not a valid folder. Returning an empty list.');
      }

      return [];
    }

    // Getting only the MP3 files from the folder
    final List<String> filePaths = folder.listSync(recursive: true).where((file) {
      return file.path.split('.').last.toUpperCase() == 'MP3';
    }).map<String>((file) {
      return file.path;
    }).toList();

    // Grabbing the [Song]s already added to the database, then:
    // 1. All songs within [databaseSongs] that exist in [files] will not be processed
    // 2. All songs within [databaseSongs] that do not exist will be deleted from the database
    List<Song> databaseSongs = await _getPlaylistSongsInDatabase(playlist.id!);
    for (final song in databaseSongs) {
      if (!File(song.path).existsSync()) {
        await database.delete(
          Database.songsTableName,
          id: song.id!,
        );
      } else if (filePaths.contains(song.path)) {
        filePaths.remove(song.path);
      }
    }

    // Grabbing the (ID3) data from the MP3 (name, artist, album, cover, & duration)
    //
    // We also add every [Song] to the database
    for (final path in filePaths) {
      final tag = ID3TagReader.path(path).readTagSync();

      late final String title;

      if (tag.title != null) {
        title = tag.title!;
      } else {
        final String pathWithExtension = path.split(PlatformHelper.slash).last;
        title = pathWithExtension.substring(
          0,
          pathWithExtension.indexOf(pathWithExtension.split('.').last) - 1,
        );
      }

      await database.insert(
        Database.songsTableName,
        data: Song(
          playlistId: playlist.id!,
          path: path,
          cover: tag.pictures.isNotEmpty ? Uint8List.fromList(tag.pictures.first.imageData) : null,
          title: title,
          artist: tag.artist,
          album: tag.album,
          duration: MP3Processor.fromFile(File(path)).duration,
        ).toJson(),
      );
    }

    // Finally, we retrieve and return the songs we just added to the database
    return await _getPlaylistSongsInDatabase(playlist.id!);
  }

  /// Helper function to select the [Song]s with a given [Playlist.id]
  Future<List<Song>> _getPlaylistSongsInDatabase(int playlistId) async {
    final List<Map<String, dynamic>> rows = await database.select(
      Database.songsTableName,
      conditions: Conditions({Song.playlistIdJsonKey: playlistId}),
    );
    return rows.map<Song>((json) => Song.fromJson(json)).toList();
  }
}
