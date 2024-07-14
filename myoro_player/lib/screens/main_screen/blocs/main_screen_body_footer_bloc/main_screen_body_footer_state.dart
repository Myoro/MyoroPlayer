// coverage:ignore-file

import 'package:equatable/equatable.dart';
import 'package:myoro_player/shared/models/playlist.dart';
import 'package:myoro_player/shared/models/song.dart';
import 'package:kplayer/kplayer.dart';

final class MainScreenBodyFooterState extends Equatable {
  /// The audio player
  final PlayerController? player;

  /// Loaded [Playlist] that is used to, for example, pick/choose new songs
  final Playlist? loadedPlaylist;

  /// The [Song] that is loaded and, for example, could be playing
  final (Song song, bool cacheSong)? loadedSong;

  /// The [Song] that was last played from [loadedPlaylist]
  ///
  /// Used to pick new songs with [NextSongEvent] is called
  final Song? lastPlaylistSong;

  /// Queued [Song]s
  final List<Song> queue;

  /// Previous played (cached) songs
  final List<Song> cache;

  const MainScreenBodyFooterState({
    this.player,
    this.loadedPlaylist,
    this.loadedSong,
    this.lastPlaylistSong,
    this.queue = const [],
    this.cache = const [],
  });

  MainScreenBodyFooterState copyWith({
    PlayerController? player,
    Playlist? loadedPlaylist,
    (Song song, bool cacheSong)? loadedSong,
    Song? lastPlaylistSong,
    List<Song>? queue,
    List<Song>? cache,
  }) {
    return MainScreenBodyFooterState(
      player: player ?? this.player,
      loadedPlaylist: loadedPlaylist ?? this.loadedPlaylist,
      loadedSong: loadedSong ?? this.loadedSong,
      lastPlaylistSong: lastPlaylistSong ?? this.lastPlaylistSong,
      queue: queue ?? this.queue,
      cache: cache ?? this.cache,
    );
  }

  @override
  String toString() => 'MainScreenBodyFooterState(\n'
      '  player: $player,\n'
      '  loadedPlaylist: $loadedPlaylist,\n'
      '  loadedSong: $loadedSong,\n'
      '  lastPlaylistSong: $lastPlaylistSong,\n'
      '  queue: $queue,\n'
      '  cache: $cache,\n'
      ');';

  @override
  List<Object?> get props {
    return [
      player,
      loadedPlaylist,
      loadedSong,
      lastPlaylistSong,
      queue,
      cache,
    ];
  }
}
