import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:myoro_player/shared/helpers/platform_helper.dart';
import 'package:myoro_player/shared/models/playlist.dart';

class PlaylistHelper {
  static Future<Playlist?> createNewPlaylist() async {
    String? directory = await FilePicker.platform.saveFile(
      dialogTitle: 'Create New Playlist',
    );

    if (directory == null) return null;

    _createDirectory(directory);

    return Playlist(
      directory: directory,
      name: _getDirectoryName(directory),
    );
  }

  static Future<Playlist?> addPlaylist() async {
    final String? directory = await FilePicker.platform.getDirectoryPath();

    if (directory == null) return null;

    _createDirectory(directory);

    return Playlist(
      directory: directory,
      name: _getDirectoryName(directory),
    );
  }

  static String _getDirectoryName(String directory) {
    return directory.split(PlatformHelper.isWindows ? '\\' : '/').last;
  }

  static void _createDirectory(String directory) {
    Directory(directory).createSync();
  }
}
