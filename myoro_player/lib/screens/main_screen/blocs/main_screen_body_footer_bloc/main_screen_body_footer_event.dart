// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:myoro_player/shared/models/playlist.dart';
import 'package:myoro_player/shared/models/song.dart';

@immutable
abstract class MainScreenBodyFooterEvent {
  const MainScreenBodyFooterEvent();
}

// General operations
final class TogglePlayPauseEvent extends MainScreenBodyFooterEvent {
  const TogglePlayPauseEvent();
}

final class AddToQueueEvent extends MainScreenBodyFooterEvent {
  final Song song;

  const AddToQueueEvent(this.song);
}

final class ChangeSongPositionEvent extends MainScreenBodyFooterEvent {
  final double position;

  const ChangeSongPositionEvent(this.position);
}

final class ChangeVolumeEvent extends MainScreenBodyFooterEvent {
  final double volume;

  const ChangeVolumeEvent(this.volume);
}

final class SetLoadedPlaylistEvent extends MainScreenBodyFooterEvent {
  final Playlist playlist;

  const SetLoadedPlaylistEvent(this.playlist);
}

final class PlayQueuedSongEvent extends MainScreenBodyFooterEvent {
  final Song song;

  const PlayQueuedSongEvent(this.song);
}
//

// Primary song logic operations
final class DirectPlayEvent extends MainScreenBodyFooterEvent {
  final Song song;

  const DirectPlayEvent(this.song);
}

final class PreviousSongEvent extends MainScreenBodyFooterEvent {
  const PreviousSongEvent();
}

final class NextSongEvent extends MainScreenBodyFooterEvent {
  const NextSongEvent();
}
//