import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_bloc.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_event.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_state.dart';
import 'package:frontend/shared/enums/bloc_status_enum.dart';
import 'package:frontend/shared/helpers/file_system_helper.dart';
import 'package:frontend/shared/models/playlist.dart';
import 'package:frontend/shared/models/song.dart';
import 'package:kiwi/kiwi.dart';

import '../../../mocks/file_system_helper_mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();
  late final MainScreenBodySongListBloc bloc;
  final playlist = Playlist.mock;
  final playlistSongs = Song.mockList(10);

  setUp(() {
    kiwiContainer.registerFactory<FileSystemHelper>(
      (_) => FileSystemHelperMock.preConfigured(
        songList: playlistSongs,
      ),
    );

    bloc = MainScreenBodySongListBloc();
  });

  tearDown(() {
    bloc.close();
    kiwiContainer.clear();
  });

  test('MainScreenBodySongListBloc.LoadPlaylistSongsEvent unit test.', () {
    expectLater(
      bloc.stream,
      emitsInOrder([
        const MainScreenBodySongListState(
          status: BlocStatusEnum.loading,
        ),
        // Double [copyWith] is for line coverage
        const MainScreenBodySongListState().copyWith().copyWith(
              status: BlocStatusEnum.completed,
              loadedPlaylist: playlist,
              loadedPlaylistSongs: playlistSongs,
            ),
      ]),
    );

    bloc.add(LoadPlaylistSongsEvent(playlist));
  });
}
