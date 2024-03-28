import 'dart:io';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/shared/models/song.dart';

/// Cubit responsible for storing the songs from a playlist that has been loaded
class SongCubit extends Cubit<List<Song>> {
  SongCubit() : super([]);

  void loadPlaylist(String playlistDirectory) {
    List<String> files = _getSongs(playlistDirectory);

    // TODO: Finish implementation
  }

  List<String> _getSongs(String playlistDirectory) {
    final List<String> files = [];

    Directory(playlistDirectory).listSync().forEach((entity) {
      if (entity is File && entity.path.split('.').last.toUpperCase() == 'MP3') {
        files.add(entity.path);
      } else if (entity is Directory) {
        files.addAll(_getSongs(entity.path));
      }
    });

    return files;
  }
}
