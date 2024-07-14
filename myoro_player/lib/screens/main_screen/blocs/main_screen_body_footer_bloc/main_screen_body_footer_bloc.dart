// coverage:ignore-file

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/screens/main_screen/blocs/main_screen_body_footer_bloc/main_screen_body_footer_event.dart';
import 'package:myoro_player/screens/main_screen/blocs/main_screen_body_footer_bloc/main_screen_body_footer_state.dart';
import 'package:myoro_player/shared/models/conditions.dart';
import 'package:myoro_player/shared/models/playlist.dart';
import 'package:myoro_player/shared/models/song.dart';
import 'package:myoro_player/shared/services/playlist_service/playlist_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:kplayer/kplayer.dart';

final class MainScreenBodyFooterBloc extends Bloc<MainScreenBodyFooterEvent, MainScreenBodyFooterState> {
  final PlaylistService _playlistService = KiwiContainer().resolve<PlaylistService>();

  MainScreenBodyFooterBloc() : super(const MainScreenBodyFooterState()) {
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

    on<DirectPlayEvent>((event, emit) async {
      final loadedPlaylist = await _playlistService.get(
        conditions: Conditions({
          Playlist.idJsonKey: event.song.playlistId,
        }),
      );

      _killPlayer();

      emit(
        state.copyWith(
          player: Player.file(event.song.path),
          loadedPlaylist: loadedPlaylist,
          loadedSong: (event.song, true),
          lastPlaylistSong: event.song,
          cache: _cacheSong(),
        ),
      );
    });

    on<ChangeSongPositionEvent>((event, emit) {
      state.player?.setPosition(
        Duration(
          seconds: event.position.toInt(),
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
    state.player?.pause();
    state.player?.dispose();
  }
}
