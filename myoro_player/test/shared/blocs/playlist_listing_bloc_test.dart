import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:mocktail/mocktail.dart';
import 'package:myoro_player/shared/blocs/playlist_listing_bloc/playlist_listing_bloc.dart';
import 'package:myoro_player/shared/blocs/playlist_listing_bloc/playlist_listing_event.dart';
import 'package:myoro_player/shared/blocs/playlist_listing_bloc/playlist_listing_state.dart';
import 'package:myoro_player/core/enums/bloc_status_enum.dart';
import 'package:myoro_player/core/helpers/file_system_helper.dart';
import 'package:myoro_player/core/helpers/platform_helper.dart';
import 'package:myoro_player/core/models/playlist.dart';
import 'package:myoro_player/core/services/playlist_service/playlist_service.dart';

import '../../mocks/file_system_helper_mock.dart';
import '../../mocks/playlist_service_mock.dart';

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

  test('PlaylistListingBloc.CreatePlaylistEvent canceled operation case.', () {
    final bloc = PlaylistListingBloc();

    expectLater(
      bloc.stream,
      emits(
        // Redundant [copyWith] is for line coverage
        const PlaylistListingState().copyWith().copyWith(
              status: BlocStatusEnum.loading,
            ),
      ),
    );

    when(() => fileSystemHelperMock.createFolderDialogWindow()).thenAnswer((_) async => null);

    bloc.add(const CreatePlaylistEvent());
  });

  test('PlaylistListingBloc.CreatePlaylistEvent invalid folder name case.', () {
    final bloc = PlaylistListingBloc();

    expectLater(
      bloc.stream,
      emitsInOrder([
        const PlaylistListingState(
          status: BlocStatusEnum.loading,
        ),
        const PlaylistListingState(
          status: BlocStatusEnum.error,
          snackBarMessage: 'Playlist cannot contain these characters: \\/:*?"<>|',
        ),
      ]),
    );

    when(() => fileSystemHelperMock.createFolderDialogWindow()).thenAnswer((_) async => '/**@*#@*');

    bloc.add(const CreatePlaylistEvent());
  });

  test('PlaylistListingBloc.CreatePlaylistEvent playlist already exists case.', () {
    final bloc = PlaylistListingBloc();

    expectLater(
      bloc.stream,
      emitsInOrder([
        const PlaylistListingState(
          status: BlocStatusEnum.loading,
        ),
        const PlaylistListingState(
          status: BlocStatusEnum.error,
          snackBarMessage: 'Playlist already exists in your local database.',
        ),
      ]),
    );

    when(() => fileSystemHelperMock.createFolderDialogWindow()).thenAnswer((_) async => path);
    when(() => playlistServiceMock.create(data: any(named: 'data'))).thenAnswer((_) async => null);

    bloc.add(const CreatePlaylistEvent());
  });

  test('PlaylistListingBloc.CreatePlaylistEvent success case.', () {
    final bloc = PlaylistListingBloc();
    final playlist = Playlist.mock.copyWith(path: path);

    expectLater(
      bloc.stream,
      emitsInOrder([
        const PlaylistListingState(
          status: BlocStatusEnum.loading,
        ),
        PlaylistListingState(
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

  test('PlaylistListingBloc.OpenPlaylistsEvent success case.', () {
    final bloc = PlaylistListingBloc();
    final playlist = Playlist.mock.copyWith(path: path);

    expectLater(
      bloc.stream,
      emitsInOrder([
        const PlaylistListingState(
          status: BlocStatusEnum.loading,
        ),
        PlaylistListingState(
          status: BlocStatusEnum.completed,
          snackBarMessage: '${playlist.path} created successfully!',
        ),
      ]),
    );

    when(() => fileSystemHelperMock.openFolderDialogWindow(title: any(named: 'title'))).thenAnswer((_) async => playlist.path);
    when(() => playlistServiceMock.create(data: any(named: 'data'))).thenAnswer((_) async => playlist);

    bloc.add(const OpenPlaylistEvent());
  });

  test('PlaylistListingBloc.SetPlaylistImageEvent success case', () {
    final bloc = PlaylistListingBloc();
    final playlist = Playlist.mock;

    expectLater(
      bloc.stream,
      emitsInOrder([
        const PlaylistListingState(
          status: BlocStatusEnum.loading,
        ),
        PlaylistListingState(
          status: BlocStatusEnum.completed,
          snackBarMessage: '${playlist.name}\'s image changed successfully!',
        ),
      ]),
    );

    when(() => fileSystemHelperMock.openImageDialogWindow()).thenAnswer((_) async => 'assets/images/cat.jpg');
    when(() => playlistServiceMock.update(id: any(named: 'id'), data: any(named: 'data'))).thenAnswer((_) async => playlist);

    bloc.add(SetPlaylistImageEvent(playlist));
  });

  test('PlaylistListingBloc.RemovePlaylistFromMyoroPlayerEvent error case.', () {
    final bloc = PlaylistListingBloc();
    final playlist = Playlist.mock;

    expectLater(
      bloc.stream,
      emitsInOrder([
        const PlaylistListingState(
          status: BlocStatusEnum.loading,
        ),
        PlaylistListingState(
          status: BlocStatusEnum.error,
          snackBarMessage: 'Error removing ${playlist.name}.',
        ),
      ]),
    );

    bloc.add(RemovePlaylistFromMyoroPlayerEvent(playlist));
  });
  test('PlaylistListingBloc.RemovePlaylistFromMyoroPlayerEvent error case.', () {
    final bloc = PlaylistListingBloc();
    final playlist = Playlist.mock;

    expectLater(
      bloc.stream,
      emitsInOrder([
        const PlaylistListingState(
          status: BlocStatusEnum.loading,
        ),
        PlaylistListingState(
          status: BlocStatusEnum.error,
          snackBarMessage: 'Error removing ${playlist.name}.',
        ),
      ]),
    );

    bloc.add(RemovePlaylistFromMyoroPlayerEvent(playlist));
  });

  test('PlaylistListingBloc.RemovePlaylistFromMyoroPlayerEvent success case.', () {
    final bloc = PlaylistListingBloc();
    final playlist = Playlist.mock;

    expectLater(
      bloc.stream,
      emitsInOrder([
        const PlaylistListingState(
          status: BlocStatusEnum.loading,
        ),
        PlaylistListingState(
          status: BlocStatusEnum.completed,
          snackBarMessage: '${playlist.name} removed from MyoroPlayer successfully!',
        ),
      ]),
    );

    when(() => playlistServiceMock.delete(id: playlist.id!)).thenAnswer((_) async {});

    bloc.add(RemovePlaylistFromMyoroPlayerEvent(playlist));
  });
}
