import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_bloc.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_event.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_state.dart';
import 'package:myoro_player/shared/enums/bloc_status_enum.dart';
import 'package:myoro_player/shared/helpers/file_system_helper.dart';
import 'package:myoro_player/shared/helpers/platform_helper.dart';
import 'package:myoro_player/shared/models/playlist.dart';
import 'package:myoro_player/shared/services/playlist_service/playlist_service.dart';

import '../../../../mocks/file_system_helper_mock.dart';
import '../../../../mocks/playlist_service_mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();
  final FileSystemHelper fileSystemHelperMock = FileSystemHelperMock();
  final PlaylistService playlistServiceMock = PlaylistServiceMock();
  final path = '${PlatformHelper.slash}Name';

  setUpAll(() {
    kiwiContainer
      ..registerFactory<FileSystemHelper>((_) => fileSystemHelperMock)
      ..registerFactory<PlaylistService>((_) => playlistServiceMock);
  });

  tearDownAll(() => kiwiContainer.clear());

  test('MainScreenBodyPlaylistSideBarBloc.CreatePlaylistEvent canceled operation case.', () {
    final bloc = MainScreenBodyPlaylistSideBarBloc();

    expectLater(
      bloc.stream,
      emits(
        // Redundant [copyWith] is for line coverage
        const MainScreenBodyPlaylistSideBarState().copyWith().copyWith(
              status: BlocStatusEnum.loading,
            ),
      ),
    );

    when(() => fileSystemHelperMock.createFolderDialogWindow()).thenAnswer((_) async => null);

    bloc.add(const CreatePlaylistEvent());
  });

  test('MainScreenBodyPlaylistSideBarBloc.CreatePlaylistEvent invalid folder name case.', () {
    final bloc = MainScreenBodyPlaylistSideBarBloc();

    expectLater(
      bloc.stream,
      emitsInOrder([
        const MainScreenBodyPlaylistSideBarState(
          status: BlocStatusEnum.loading,
        ),
        const MainScreenBodyPlaylistSideBarState(
          status: BlocStatusEnum.error,
          snackBarMessage: 'Playlist cannot contain these characters: \\/:*?"<>|',
        ),
      ]),
    );

    when(() => fileSystemHelperMock.createFolderDialogWindow()).thenAnswer((_) async => '/**@*#@*');

    bloc.add(const CreatePlaylistEvent());
  });

  test('MainScreenBodyPlaylistSideBarBloc.CreatePlaylistEvent playlist already exists case.', () {
    final bloc = MainScreenBodyPlaylistSideBarBloc();

    expectLater(
      bloc.stream,
      emitsInOrder([
        const MainScreenBodyPlaylistSideBarState(
          status: BlocStatusEnum.loading,
        ),
        const MainScreenBodyPlaylistSideBarState(
          status: BlocStatusEnum.error,
          snackBarMessage: 'Playlist already exists in your local database.',
        ),
      ]),
    );

    when(() => fileSystemHelperMock.createFolderDialogWindow()).thenAnswer((_) async => path);
    when(() => playlistServiceMock.create(data: any(named: 'data'))).thenAnswer((_) async => null);

    bloc.add(const CreatePlaylistEvent());
  });

  test('MainScreenBodyPlaylistSideBarBloc.CreatePlaylistEvent success case.', () {
    final bloc = MainScreenBodyPlaylistSideBarBloc();
    final playlist = Playlist.mock.copyWith(path: path);

    expectLater(
      bloc.stream,
      emitsInOrder([
        const MainScreenBodyPlaylistSideBarState(
          status: BlocStatusEnum.loading,
        ),
        MainScreenBodyPlaylistSideBarState(
          status: BlocStatusEnum.completed,
          snackBarMessage: '${playlist.path} created successfully!',
        ),
      ]),
    );

    when(() => fileSystemHelperMock.createFolderDialogWindow()).thenAnswer((_) async => playlist.path);
    when(() => fileSystemHelperMock.createFolder(any())).thenReturn(true);
    when(() => playlistServiceMock.create(data: any(named: 'data'))).thenAnswer((_) async => playlist);

    bloc.add(const CreatePlaylistEvent());
  });

  test('MainScreenBodyPlaylistSideBarBloc.OpenPlaylistsEvent success case.', () {
    final bloc = MainScreenBodyPlaylistSideBarBloc();
    final playlist = Playlist.mock.copyWith(path: path);

    expectLater(
      bloc.stream,
      emitsInOrder([
        const MainScreenBodyPlaylistSideBarState(
          status: BlocStatusEnum.loading,
        ),
        MainScreenBodyPlaylistSideBarState(
          status: BlocStatusEnum.completed,
          snackBarMessage: '${playlist.path} created successfully!',
        ),
      ]),
    );

    when(() => fileSystemHelperMock.openFolderDialogWindow(title: any(named: 'title'))).thenAnswer((_) async => playlist.path);
    when(() => playlistServiceMock.create(data: any(named: 'data'))).thenAnswer((_) async => playlist);

    bloc.add(const OpenPlaylistEvent());
  });

  test('MainScreenBodyPlaylistSideBarBloc.SetPlaylistImageEvent success case', () {
    final bloc = MainScreenBodyPlaylistSideBarBloc();
    final playlist = Playlist.mock;

    expectLater(
      bloc.stream,
      emitsInOrder([
        const MainScreenBodyPlaylistSideBarState(
          status: BlocStatusEnum.loading,
        ),
        MainScreenBodyPlaylistSideBarState(
          status: BlocStatusEnum.completed,
          snackBarMessage: '${playlist.name}\'s image changed successfully!',
        ),
      ]),
    );

    when(() => fileSystemHelperMock.openImageDialogWindow()).thenAnswer((_) async => 'assets/images/cat.jpg');
    when(() => playlistServiceMock.update(id: any(named: 'id'), data: any(named: 'data'))).thenAnswer((_) async => playlist);

    bloc.add(SetPlaylistImageEvent(playlist));
  });

  test('MainScreenBodyPlaylistSideBarBloc.RemovePlaylistFromMyoroPlayerEvent error case.', () {
    final bloc = MainScreenBodyPlaylistSideBarBloc();
    final playlist = Playlist.mock;

    expectLater(
      bloc.stream,
      emitsInOrder([
        const MainScreenBodyPlaylistSideBarState(
          status: BlocStatusEnum.loading,
        ),
        MainScreenBodyPlaylistSideBarState(
          status: BlocStatusEnum.error,
          snackBarMessage: 'Error removing ${playlist.name}.',
        ),
      ]),
    );

    bloc.add(RemovePlaylistFromMyoroPlayerEvent(playlist));
  });
  test('MainScreenBodyPlaylistSideBarBloc.RemovePlaylistFromMyoroPlayerEvent error case.', () {
    final bloc = MainScreenBodyPlaylistSideBarBloc();
    final playlist = Playlist.mock;

    expectLater(
      bloc.stream,
      emitsInOrder([
        const MainScreenBodyPlaylistSideBarState(
          status: BlocStatusEnum.loading,
        ),
        MainScreenBodyPlaylistSideBarState(
          status: BlocStatusEnum.error,
          snackBarMessage: 'Error removing ${playlist.name}.',
        ),
      ]),
    );

    bloc.add(RemovePlaylistFromMyoroPlayerEvent(playlist));
  });

  test('MainScreenBodyPlaylistSideBarBloc.RemovePlaylistFromMyoroPlayerEvent success case.', () {
    final bloc = MainScreenBodyPlaylistSideBarBloc();
    final playlist = Playlist.mock;

    expectLater(
      bloc.stream,
      emitsInOrder([
        const MainScreenBodyPlaylistSideBarState(
          status: BlocStatusEnum.loading,
        ),
        MainScreenBodyPlaylistSideBarState(
          status: BlocStatusEnum.completed,
          snackBarMessage: '${playlist.name} removed from MyoroPlayer successfully!',
        ),
      ]),
    );

    when(() => playlistServiceMock.delete(id: playlist.id!)).thenAnswer((_) async {});

    bloc.add(RemovePlaylistFromMyoroPlayerEvent(playlist));
  });
}
