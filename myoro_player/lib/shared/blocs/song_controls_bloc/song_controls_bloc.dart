// coverage:ignore-file

import 'dart:math';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/shared/blocs/song_controls_bloc/song_controls_event.dart';
import 'package:myoro_player/shared/blocs/song_controls_bloc/song_controls_state.dart';
import 'package:myoro_player/shared/blocs/user_preferences_cubit.dart';
import 'package:myoro_player/shared/models/conditions.dart';
import 'package:myoro_player/shared/models/playlist.dart';
import 'package:myoro_player/shared/models/song.dart';
import 'package:myoro_player/shared/models/user_preferences.dart';
import 'package:myoro_player/shared/services/playlist_service/playlist_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:kplayer/kplayer.dart';
import 'package:myoro_player/shared/services/song_service/song_service.dart';
import 'package:myoro_player/shared/services/user_preferences_service/user_preferences_service.dart';

/// BloC for creating and managing MyoroPlayer's audio player
final class SongControlsBloc extends Bloc<SongControlsEvent, SongControlsState> {
  late final UserPreferencesService _userPreferencesService;
  late final PlaylistService _playlistService;
  late final SongService _songService;
  late final UserPreferencesCubit _userPreferencesCubit;

  SongControlsBloc(
    UserPreferencesCubit userPreferencesCubit,
  ) : super(const SongControlsState()) {
    final kiwiContainer = KiwiContainer();
    _userPreferencesService = kiwiContainer.resolve<UserPreferencesService>();
    _playlistService = kiwiContainer.resolve<PlaylistService>();
    _songService = kiwiContainer.resolve<SongService>();
    _userPreferencesCubit = userPreferencesCubit;

    on<AddToQueueEvent>((event, emit) {
      emit(
        state.copyWith(
          queue: List.from(state.queue)..add(event.song),
        ),
      );
    });

    on<TogglePlayPauseEvent>((event, emit) {
      if (state.player?.playing == true) {
        state.player?.pause();
      } else {
        state.player?.play();
      }
    });

    on<ChangeSongPositionEvent>((event, emit) {
      state.player?.setPosition(
        Duration(
          seconds: event.position.toInt(),
        ),
      );
    });

    on<ChangeVolumeEvent>((event, emit) async {
      await _userPreferencesCubit.setVolume(event.volume);
      state.player?.setVolume(event.volume);
    });

    on<SetLoadedPlaylistEvent>((event, emit) async {
      emit(
        state.copyWith(
          loadedPlaylist: event.playlist,
          randomizedLoadedPlaylistSongs: await _randomizePlaylist(event.playlist),
        ),
      );
    });

    on<PlayQueuedSongEvent>((event, emit) async {
      _killPlayer();

      emit(
        state.copyWith(
          player: await _initPlayer(event.song),
          loadedSong: (event.song, true),
          queue: List.from(state.queue)..remove(event.song),
          cache: _cacheSong(),
        ),
      );
    });

    on<DirectPlayEvent>((event, emit) async {
      final loadedPlaylist = await _playlistService.get(
        conditions: Conditions({
          Playlist.idJsonKey: event.song.playlistId,
        }),
      );

      _killPlayer();

      emit(
        state.copyWith(
          player: await _initPlayer(event.song),
          loadedPlaylist: loadedPlaylist,
          randomizedLoadedPlaylistSongs: await _randomizePlaylist(loadedPlaylist!),
          loadedSong: (event.song, true),
          lastPlaylistSong: event.song,
          cache: _cacheSong(),
        ),
      );
    });

    on<PreviousSongEvent>((event, emit) async {
      if (state.cache.isEmpty) return;

      final List<Song> cache = List.from(state.cache);
      final Song song = cache.removeLast();

      _killPlayer();

      emit(
        state.copyWith(
          player: await _initPlayer(song),
          loadedSong: (song, false),
          lastPlaylistSong: song.playlistId == state.loadedPlaylist?.id ? song : null,
          cache: cache,
        ),
      );
    });

    on<NextSongEvent>((event, emit) async {
      // Step 1: Check if queue is empty
      if (state.queue.isNotEmpty) {
        final List<Song> queue = List.from(state.queue);
        final Song song = queue.removeLast();

        _killPlayer();

        emit(
          state.copyWith(
            player: await _initPlayer(song),
            loadedSong: (song, true),
            queue: queue,
            cache: _cacheSong(),
          ),
        );

        return;
      }

      final UserPreferences userPreferences = (await _userPreferencesService.get())!;

      // Step 2: Check if repeat is enabled
      if (userPreferences.repeat) {
        if (state.player != null) {
          state.player!.setPosition(const Duration(seconds: 0));
          state.player!.play();
        }

        return;
      }

      // Step 3: Check if [state.loadedPlaylist] is not null. if it is
      // null, this is an end case, as we cannot choose the next song.
      if (state.loadedPlaylist == null) return;

      // Step 4: Check if shuffle is enabled
      late final Song nextSong;
      if (userPreferences.shuffle) {
        final int? lastPlaylistSongIndex = state.lastPlaylistSong != null ? state.randomizedLoadedPlaylistSongs!.indexOf(state.lastPlaylistSong!) : null;
        nextSong = state.randomizedLoadedPlaylistSongs!.elementAt(
          lastPlaylistSongIndex != null
              ? lastPlaylistSongIndex != state.randomizedLoadedPlaylistSongs!.length - 1
                  ? lastPlaylistSongIndex + 1
                  : 0
              : 0,
        );
      } else {
        final List<Song> songs = await _songService.select(
          conditions: Conditions(
            {
              Song.playlistIdJsonKey: state.loadedPlaylist!.id,
            },
          ),
        );
        final int? lastPlaylistSongIndex = state.lastPlaylistSong != null ? songs.indexOf(state.lastPlaylistSong!) : null;
        nextSong = songs.elementAt(
          lastPlaylistSongIndex != null
              ? lastPlaylistSongIndex != songs.length - 1
                  ? lastPlaylistSongIndex + 1
                  : 0
              : 0,
        );
      }

      _killPlayer();

      emit(
        state.copyWith(
          player: await _initPlayer(nextSong),
          loadedSong: (nextSong, true),
          lastPlaylistSong: nextSong,
          cache: _cacheSong(),
        ),
      );
    });
  }

  List<Song> _cacheSong() {
    final List<Song> cache = List.from(state.cache);
    if (state.loadedSong?.$2 == true) cache.add(state.loadedSong!.$1);
    return cache;
  }

  void _killPlayer() {
    state.player?.stop();
    state.player?.dispose();
  }

  Future<PlayerController> _initPlayer(Song song) async {
    final player = Player.file(song.path);
    player.setVolume((await _userPreferencesService.get())!.volume);
    return player;
  }

  Future<List<Song>> _randomizePlaylist(Playlist loadedPlaylist) async {
    final List<Song> loadedPlaylistSongs = await _songService.select(
      conditions: Conditions({
        Song.playlistIdJsonKey: loadedPlaylist.id,
      }),
    );

    final List<Song> randomizedSongs = [];

    for (int i = 0; i < loadedPlaylistSongs.length; i++) {
      final song = loadedPlaylistSongs[Random().nextInt(loadedPlaylistSongs.length)];
      randomizedSongs.add(song);
      loadedPlaylistSongs.remove(song);
    }

    return randomizedSongs;
  }
}
