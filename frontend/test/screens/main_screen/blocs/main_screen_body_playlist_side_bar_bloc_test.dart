import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:mocktail/mocktail.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_bloc.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_event.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_state.dart';
import 'package:frontend/shared/enums/bloc_status_enum.dart';
import 'package:frontend/shared/helpers/file_system_helper.dart';
import 'package:frontend/shared/helpers/platform_helper.dart';
import 'package:frontend/shared/models/playlist.dart';
import 'package:frontend/shared/services/playlist_service/playlist_service.dart';

import '../../../mocks/file_system_helper_mock.dart';
import '../../../mocks/playlist_service_mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();
  final FileSystemHelper fileSystemHelperMock = FileSystemHelperMock();
  final PlaylistService playlistServiceMock = PlaylistServiceMock();
  final path = '${PlatformHelper.isWindows ? '\\' : '/'}Name';

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

    when(() => fileSystemHelperMock.createFolderDialogWindow())
        .thenAnswer((_) async => playlist.path);
    when(() => fileSystemHelperMock.createFolder(any())).thenReturn(true);
    when(() => playlistServiceMock.create(data: any(named: 'data')))
        .thenAnswer((_) async => playlist);

    bloc.add(const CreatePlaylistEvent());
  });
}
