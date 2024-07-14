// coverage:ignore-file

import 'package:flutter/material.dart';
import 'package:frontend/shared/models/song.dart';

@immutable
abstract class MainScreenBodyFooterEvent {
  const MainScreenBodyFooterEvent();
}

final class TogglePlayPauseEvent extends MainScreenBodyFooterEvent {
  const TogglePlayPauseEvent();
}

final class AddToQueueEvent extends MainScreenBodyFooterEvent {
  final Song song;

  const AddToQueueEvent(this.song);
}

final class DirectPlayEvent extends MainScreenBodyFooterEvent {
  final Song song;

  const DirectPlayEvent(this.song);
}

final class ChangeSongPositionEvent extends MainScreenBodyFooterEvent {
  final double position;

  const ChangeSongPositionEvent(this.position);
}
