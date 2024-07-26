import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/core/helpers/platform_helper.dart';
import 'package:myoro_player/shared/blocs/playlist_listing_bloc/playlist_listing_bloc.dart';
import 'package:myoro_player/core/blocs/model_resolver_bloc/model_resolver_bloc.dart';
import 'package:myoro_player/core/controllers/model_resolver_controller.dart';
import 'package:myoro_player/core/helpers/file_system_helper.dart';
import 'package:myoro_player/core/models/playlist.dart';
import 'package:myoro_player/core/services/playlist_service/playlist_service.dart';
import 'package:myoro_player/core/widgets/modals/base_modal.dart';
import 'package:myoro_player/core/widgets/modals/delete_playlist_from_device_confirmation_modal.dart';
import 'package:kiwi/kiwi.dart';
import 'package:mocktail/mocktail.dart';

import '../../../base_test_widget.dart';
import '../../../mocks/file_system_helper_mock.dart';
import '../../../mocks/platform_helper_mock.dart';
import '../../../mocks/playlist_service_mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();
  final PlaylistService playlistServiceMock = PlaylistServiceMock();
  late final PlaylistListingBloc mainScreenBodyPlaylistSideBarBloc;
  final playlistResolver = ModelResolverController<List<Playlist>>();
  final key = UniqueKey();
  final playlist = Playlist.mock;

  setUpAll(() {
    kiwiContainer
      ..registerFactory<PlatformHelper>((_) => PlatformHelperMock.preConfigured())
      ..registerFactory<FileSystemHelper>((_) => FileSystemHelperMock.preConfigured())
      ..registerFactory<PlaylistService>((_) => playlistServiceMock);

    playlistResolver.bloc = ModelResolverBloc<List<Playlist>>();
    playlistResolver.request = () async => [Playlist.mock];

    mainScreenBodyPlaylistSideBarBloc = PlaylistListingBloc();
  });

  tearDownAll(() {
    kiwiContainer.clear();
    mainScreenBodyPlaylistSideBarBloc.close();
  });

  Widget widget() {
    return BaseTestWidget(
      child: BlocProvider.value(
        value: mainScreenBodyPlaylistSideBarBloc,
        child: Builder(
          builder: (context) {
            return GestureDetector(
              key: key,
              onTap: () {
                DeletePlaylistFromDeviceConfirmationModal.show(
                  context,
                  playlist: playlist,
                  playlistResolverController: playlistResolver,
                );
              },
            );
          },
        ),
      ),
    );
  }

  void expectCalls() {
    expect(find.byType(DeletePlaylistFromDeviceConfirmationModal), findsOneWidget);
    expect(find.byType(BaseModal), findsOneWidget);
    expect(find.text('Delete ${playlist.name} from device'), findsOneWidget);
    expect(find.text('Are you sure you want to delete ${playlist.name}? This is not reversible!'), findsOneWidget);
  }

  testWidgets('DeletePlaylistFromDeviceConfirmationModal error case widget test.', (tester) async {
    await tester.pumpWidget(widget());
    await tester.tap(find.byKey(key));
    await tester.pump();
    expectCalls();
    await tester.tap(find.text('Confirm'));
  });

  testWidgets('DeletePlaylistFromDeviceConfirmationModal success case widget test.', (tester) async {
    await tester.pumpWidget(widget());
    await tester.tap(find.byKey(key));
    await tester.pump();
    expectCalls();
    when(() => playlistServiceMock.delete(id: any(named: 'id'))).thenAnswer((_) async {});
    await tester.tap(find.text('Confirm'));
  });
}
