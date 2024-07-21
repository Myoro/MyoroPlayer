// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:myoro_player/core/models/playlist.dart';
import 'package:myoro_player/core/models/song.dart';

@immutable
abstract class SongControlsEvent {
  const SongControlsEvent();
}

// General operations
final class TogglePlayPauseEvent extends SongControlsEvent {
  const TogglePlayPauseEvent();
}

final class AddToQueueEvent extends SongControlsEvent {
  final Song song;

  const AddToQueueEvent(this.song);
}

final class ChangeSongPositionEvent extends SongControlsEvent {
  final double position;

  const ChangeSongPositionEvent(this.position);
}

final class ChangeVolumeEvent extends SongControlsEvent {
  final double volume;

  const ChangeVolumeEvent(this.volume);
}

final class SetLoadedPlaylistEvent extends SongControlsEvent {
  final Playlist playlist;

  const SetLoadedPlaylistEvent(this.playlist);
}

final class PlayQueuedSongEvent extends SongControlsEvent {
  final Song song;

  const PlayQueuedSongEvent(this.song);
}
//

// Primary song logic operations
final class DirectPlayEvent extends SongControlsEvent {
  final Song song;

  const DirectPlayEvent(this.song);
}

final class PreviousSongEvent extends SongControlsEvent {
  const PreviousSongEvent();
}

final class NextSongEvent extends SongControlsEvent {
  const NextSongEvent();
}
//
