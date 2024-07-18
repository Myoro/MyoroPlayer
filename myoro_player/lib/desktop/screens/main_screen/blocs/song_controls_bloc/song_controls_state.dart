// coverage:ignore-file

import 'package:equatable/equatable.dart';
import 'package:myoro_player/shared/models/playlist.dart';
import 'package:myoro_player/shared/models/song.dart';
import 'package:kplayer/kplayer.dart';

final class SongControlsState extends Equatable {
  /// The audio player
  final PlayerController? player;

  /// Loaded [Playlist] that is used to, for example, pick/choose new songs
  final Playlist? loadedPlaylist;

  /// [loadedPlaylist] [Song]s randomized
  ///
  /// Works like Spotify's smart shuffle to prevent repititions when shuffle is enabled
  final List<Song>? randomizedLoadedPlaylistSongs;

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

  const SongControlsState({
    this.player,
    this.loadedPlaylist,
    this.randomizedLoadedPlaylistSongs,
    this.loadedSong,
    this.lastPlaylistSong,
    this.queue = const [],
    this.cache = const [],
  });

  SongControlsState copyWith({
    PlayerController? player,
    Playlist? loadedPlaylist,
    List<Song>? randomizedLoadedPlaylistSongs,
    (Song song, bool cacheSong)? loadedSong,
    Song? lastPlaylistSong,
    List<Song>? queue,
    List<Song>? cache,
  }) {
    return SongControlsState(
      player: player ?? this.player,
      loadedPlaylist: loadedPlaylist ?? this.loadedPlaylist,
      randomizedLoadedPlaylistSongs: randomizedLoadedPlaylistSongs ?? this.randomizedLoadedPlaylistSongs,
      loadedSong: loadedSong ?? this.loadedSong,
      lastPlaylistSong: lastPlaylistSong ?? this.lastPlaylistSong,
      queue: queue ?? this.queue,
      cache: cache ?? this.cache,
    );
  }

  @override
  String toString() => 'SongControlsState(\n'
      '  player: $player,\n'
      '  loadedPlaylist: $loadedPlaylist,\n'
      '  randomizedLoadedPlaylistSongs: $randomizedLoadedPlaylistSongs,\n'
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
      randomizedLoadedPlaylistSongs,
      loadedSong,
      lastPlaylistSong,
      queue,
      cache,
    ];
  }
}
