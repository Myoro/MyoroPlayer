import 'package:flutter/material.dart';
import 'package:myoro_player/shared/models/playlist.dart';

@immutable
abstract class PlaylistListingEvent {
  const PlaylistListingEvent();
}

final class CreatePlaylistEvent extends PlaylistListingEvent {
  const CreatePlaylistEvent();
}

final class OpenPlaylistEvent extends PlaylistListingEvent {
  const OpenPlaylistEvent();
}

final class SetPlaylistImageEvent extends PlaylistListingEvent {
  final Playlist playlist;
  final bool removeImage;

  const SetPlaylistImageEvent(this.playlist, {this.removeImage = false});
}

final class RemovePlaylistFromMyoroPlayerEvent extends PlaylistListingEvent {
  final Playlist playlist;

  const RemovePlaylistFromMyoroPlayerEvent(this.playlist);
}
