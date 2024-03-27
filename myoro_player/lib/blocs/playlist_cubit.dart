import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/database.dart';
import 'package:myoro_player/helpers/platform_helper.dart';
import 'package:myoro_player/models/playlist.dart';

/// Controls all playlist logic in the application
///
/// i.e. Adding playlists, opening playlists, etc
class PlaylistCubit extends Cubit<List<Playlist>> {
  PlaylistCubit() : super([]);

  void getPlaylists() async {
    final List<Map<String, Object?>> rows = await Database.select('playlists');
    emit(rows.map((json) => Playlist.fromJson(json)).toList());
  }

  void addPlaylist() async {
    String? folder = await FilePicker.platform.saveFile(
      dialogTitle: 'Create New Playlist',
    );
    if (folder == null) return;
    final String folderName = folder.split(PlatformHelper.isWindows ? '\\' : '/').last;

    Directory(folder).createSync();

    await Database.insert(
      'playlists',
      {
        'directory': folder,
        'name': folderName,
      },
    );
    getPlaylists();
  }
}
