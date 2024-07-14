import 'package:flutter/material.dart';
import 'package:myoro_player/shared/models/playlist.dart';
import 'package:myoro_player/shared/models/song.dart';

@immutable
abstract class MainScreenBodySongListEvent {
  const MainScreenBodySongListEvent();
}

final class LoadPlaylistSongsEvent extends MainScreenBodySongListEvent {
  final Playlist playlist;

  const LoadPlaylistSongsEvent(this.playlist);
}

final class CopySongToPlaylistEvent extends MainScreenBodySongListEvent {
  final Song song;

  const CopySongToPlaylistEvent(this.song);
}

final class MoveSongToPlaylistEvent extends MainScreenBodySongListEvent {
  final Song song;

  const MoveSongToPlaylistEvent(this.song);
}

final class DeleteSongFromDeviceEvent extends MainScreenBodySongListEvent {
  final Song song;

  const DeleteSongFromDeviceEvent(this.song);
}
