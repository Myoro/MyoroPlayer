import 'package:flutter/material.dart';
import 'package:myoro_player/shared/models/playlist.dart';
import 'package:myoro_player/shared/models/song.dart';

@immutable
abstract class SongListingEvent {
  const SongListingEvent();
}

final class LoadPlaylistSongsEvent extends SongListingEvent {
  final Playlist playlist;

  const LoadPlaylistSongsEvent(this.playlist);
}

final class CopySongToPlaylistEvent extends SongListingEvent {
  final Song song;

  const CopySongToPlaylistEvent(this.song);
}

final class MoveSongToPlaylistEvent extends SongListingEvent {
  final Song song;

  const MoveSongToPlaylistEvent(this.song);
}

final class DeleteSongFromDeviceEvent extends SongListingEvent {
  final Song song;

  const DeleteSongFromDeviceEvent(this.song);
}
