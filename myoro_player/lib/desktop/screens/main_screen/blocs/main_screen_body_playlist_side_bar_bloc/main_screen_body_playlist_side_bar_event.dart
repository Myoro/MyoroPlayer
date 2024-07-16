import 'package:flutter/material.dart';
import 'package:myoro_player/shared/models/playlist.dart';

@immutable
abstract class MainScreenBodyPlaylistSideBarEvent {
  const MainScreenBodyPlaylistSideBarEvent();
}

final class CreatePlaylistEvent extends MainScreenBodyPlaylistSideBarEvent {
  const CreatePlaylistEvent();
}

final class OpenPlaylistEvent extends MainScreenBodyPlaylistSideBarEvent {
  const OpenPlaylistEvent();
}

final class SetPlaylistImageEvent extends MainScreenBodyPlaylistSideBarEvent {
  final Playlist playlist;
  final bool removeImage;

  const SetPlaylistImageEvent(this.playlist, {this.removeImage = false});
}

final class RemovePlaylistFromMyoroPlayerEvent extends MainScreenBodyPlaylistSideBarEvent {
  final Playlist playlist;

  const RemovePlaylistFromMyoroPlayerEvent(this.playlist);
}
