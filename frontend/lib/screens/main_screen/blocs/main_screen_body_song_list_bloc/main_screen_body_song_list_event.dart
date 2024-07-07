import 'package:flutter/material.dart';
import 'package:frontend/shared/models/playlist.dart';

@immutable
abstract class MainScreenBodySongListEvent {
  const MainScreenBodySongListEvent();
}

final class LoadPlaylistSongsEvent extends MainScreenBodySongListEvent {
  final Playlist playlist;

  const LoadPlaylistSongsEvent(this.playlist);
}
