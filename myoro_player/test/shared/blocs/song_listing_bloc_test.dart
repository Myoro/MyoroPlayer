import 'package:faker/faker.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/shared/blocs/song_listing_bloc/song_listing_bloc.dart';
import 'package:myoro_player/shared/blocs/song_listing_bloc/song_listing_event.dart';
import 'package:myoro_player/shared/blocs/song_listing_bloc/song_listing_state.dart';
import 'package:myoro_player/core/enums/bloc_status_enum.dart';
import 'package:myoro_player/core/helpers/file_system_helper.dart';
import 'package:myoro_player/core/models/playlist.dart';
import 'package:myoro_player/core/models/song.dart';
import 'package:myoro_player/core/services/song_service/song_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:mocktail/mocktail.dart';

import '../../mocks/file_system_helper_mock.dart';
import '../../mocks/song_service.mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();
  final FileSystemHelper fileSystemHelperMock = FileSystemHelperMock();
  final playlist = Playlist.mock;
  final playlistSongs = Song.mockList(10);
  final song = Song.mock;
  final folderPath = faker.randomGenerator.string(50);
  final newFilePath = faker.randomGenerator.string(50);

  setUp(() {
    kiwiContainer
      ..registerFactory<FileSystemHelper>((_) => fileSystemHelperMock)
      ..registerFactory<SongService>((_) => SongServiceMock.preConfigured());
  });

  tearDown(() {
    kiwiContainer.clear();
  });

  test('SongListingBloc.LoadPlaylistSongsEvent unit test.', () {
    final bloc = SongListingBloc();

    expectLater(
      bloc.stream,
      emitsInOrder([
        const SongListingState(
          status: BlocStatusEnum.loading,
        ),
        // Double [copyWith] is for line coverage
        const SongListingState().copyWith().copyWith(
              status: BlocStatusEnum.completed,
              loadedPlaylist: playlist,
              loadedPlaylistSongs: playlistSongs,
            ),
      ]),
    );

    when(
      () => fileSystemHelperMock.getMp3FilesFromFolder(
        playlist,
      ),
    ).thenAnswer(
      (_) async => playlistSongs,
    );

    bloc.add(LoadPlaylistSongsEvent(playlist));
  });

  test('SongListingBloc.CopySongToPlaylistEvent error case.', () {
    final bloc = SongListingBloc();

    expectLater(
      bloc.stream,
      emits(
        SongListingState(
          status: BlocStatusEnum.error,
          snackBarMessage: 'Error copying ${song.title} to $folderPath.',
        ),
      ),
    );

    when(
      () => fileSystemHelperMock.openFolderDialogWindow(
        title: any(named: 'title'),
      ),
    ).thenAnswer(
      (_) async => folderPath,
    );

    bloc.add(CopySongToPlaylistEvent(song));
  });

  test('SongListingBloc.CopySongToPlaylistEvent success case.', () {
    final bloc = SongListingBloc();

    expectLater(
      bloc.stream,
      emits(
        SongListingState(
          status: BlocStatusEnum.completed,
          snackBarMessage: '${song.title} copied to $folderPath successfully!',
        ),
      ),
    );

    when(
      () => fileSystemHelperMock.openFolderDialogWindow(
        title: any(named: 'title'),
      ),
    ).thenAnswer(
      (_) async => folderPath,
    );

    when(
      () => fileSystemHelperMock.copyFile(
        any(),
        any(),
      ),
    ).thenReturn(newFilePath);

    bloc.add(CopySongToPlaylistEvent(song));
  });

  test('SongListingBloc.MoveSongToPlaylistEvent error case.', () {
    final bloc = SongListingBloc();

    expectLater(
      bloc.stream,
      emits(
        SongListingState(
          status: BlocStatusEnum.error,
          snackBarMessage: 'Error moving ${song.title} to $folderPath.',
        ),
      ),
    );

    when(
      () => fileSystemHelperMock.openFolderDialogWindow(
        title: any(named: 'title'),
      ),
    ).thenAnswer(
      (_) async => folderPath,
    );

    bloc.add(MoveSongToPlaylistEvent(song));
  });

  test('SongListingBloc.MoveSongToPlaylistEvent success case.', () {
    final bloc = SongListingBloc()
      ..add(
        LoadPlaylistSongsEvent(playlist),
      );

    expectLater(
      bloc.stream,
      emitsInOrder([
        const SongListingState(
          status: BlocStatusEnum.loading,
        ),
        SongListingState(
          status: BlocStatusEnum.completed,
          loadedPlaylist: playlist,
          loadedPlaylistSongs: playlistSongs,
        ),
        SongListingState(
          status: BlocStatusEnum.completed,
          snackBarMessage: '${song.title} moved to $folderPath successfully!',
          loadedPlaylist: playlist,
          loadedPlaylistSongs: List.from(playlistSongs)..remove(song),
        ),
      ]),
    );

    when(
      () => fileSystemHelperMock.openFolderDialogWindow(
        title: any(named: 'title'),
      ),
    ).thenAnswer(
      (_) async => folderPath,
    );

    when(
      () => fileSystemHelperMock.moveFile(
        any(),
        any(),
      ),
    ).thenReturn(newFilePath);

    when(
      () => fileSystemHelperMock.getMp3FilesFromFolder(
        playlist,
      ),
    ).thenAnswer(
      (_) async => playlistSongs,
    );

    bloc.add(MoveSongToPlaylistEvent(song));
  });

  test('SongListingBloc.DeleteSongFromDeviceEvent error case unit test.', () {
    final bloc = SongListingBloc()
      ..add(
        LoadPlaylistSongsEvent(playlist),
      );

    expectLater(
      bloc.stream,
      emitsInOrder([
        const SongListingState(
          status: BlocStatusEnum.loading,
        ),
        SongListingState(
          status: BlocStatusEnum.completed,
          loadedPlaylist: playlist,
          loadedPlaylistSongs: playlistSongs,
        ),
        SongListingState(
          status: BlocStatusEnum.error,
          snackBarMessage: 'Error deleting ${song.title} from your device.',
          loadedPlaylist: playlist,
          loadedPlaylistSongs: playlistSongs,
        ),
      ]),
    );

    when(() => fileSystemHelperMock.deleteFile(any())).thenReturn(false);

    bloc.add(DeleteSongFromDeviceEvent(song));
  });

  test('SongListingBloc.DeleteSongFromDeviceEvent success case unit test.', () {
    final bloc = SongListingBloc()
      ..add(
        LoadPlaylistSongsEvent(playlist),
      );

    expectLater(
      bloc.stream,
      emitsInOrder([
        const SongListingState(
          status: BlocStatusEnum.loading,
        ),
        SongListingState(
          status: BlocStatusEnum.completed,
          loadedPlaylist: playlist,
          loadedPlaylistSongs: playlistSongs,
        ),
        SongListingState(
          status: BlocStatusEnum.completed,
          snackBarMessage: '${song.title} deleted from your device successfully!',
          loadedPlaylist: playlist,
          loadedPlaylistSongs: List.from(playlistSongs)..remove(song),
        ),
      ]),
    );

    when(() => fileSystemHelperMock.deleteFile(any())).thenReturn(true);

    bloc.add(DeleteSongFromDeviceEvent(song));
  });
}
