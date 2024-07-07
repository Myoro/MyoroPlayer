import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_event.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_state.dart';
import 'package:frontend/shared/enums/bloc_status_enum.dart';
import 'package:frontend/shared/helpers/file_system_helper.dart';
import 'package:frontend/shared/models/song.dart';
import 'package:kiwi/kiwi.dart';

final class MainScreenBodySongListBloc extends Bloc<MainScreenBodySongListEvent, MainScreenBodySongListState> {
  final _fileSystemHelper = KiwiContainer().resolve<FileSystemHelper>();

  MainScreenBodySongListBloc() : super(const MainScreenBodySongListState()) {
    on<LoadPlaylistSongsEvent>((event, emit) async {
      emit(state.copyWith(status: BlocStatusEnum.loading));

      // Grabbing all of the MP3 files within the playlist
      final List<Song> loadedPlaylistSongs = await _fileSystemHelper.getMp3FilesFromFolder(
        event.playlist,
      );

      emit(
        state.copyWith(
          status: BlocStatusEnum.completed,
          loadedPlaylist: event.playlist,
          loadedPlaylistSongs: loadedPlaylistSongs,
        ),
      );
    });
  }
}
