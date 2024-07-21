import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/shared/blocs/playlist_listing_bloc/playlist_listing_bloc.dart';
import 'package:myoro_player/shared/enums/playlist_listing_playlist_menu_enum.dart';
import 'package:myoro_player/core/controllers/model_resolver_controller.dart';
import 'package:myoro_player/core/helpers/file_system_helper.dart';
import 'package:myoro_player/core/models/playlist.dart';
import 'package:myoro_player/core/services/playlist_service/playlist_service.dart';
import 'package:myoro_player/core/widgets/modals/rename_playlist_modal.dart';
import 'package:kiwi/kiwi.dart';

import '../../base_test_widget.dart';
import '../../mocks/file_system_helper_mock.dart';
import '../../mocks/playlist_service_mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();
  late final PlaylistListingBloc mainScreenBodyPlaylistSideBarBloc;
  const key = Key('');
  late final Widget widget;

  setUpAll(() {
    kiwiContainer
      ..registerFactory<FileSystemHelper>((_) => FileSystemHelperMock.preConfigured())
      ..registerFactory<PlaylistService>((_) => PlaylistServiceMock.preConfigured());

    mainScreenBodyPlaylistSideBarBloc = PlaylistListingBloc();

    widget = BaseTestWidget(
      child: BlocProvider.value(
        value: mainScreenBodyPlaylistSideBarBloc,
        child: Builder(
          builder: (context) {
            return GestureDetector(
              key: key,
              onSecondaryTapDown: (details) {
                PlaylistListingPlaylistMenuEnum.showContextMenu(
                  context,
                  details,
                  Playlist.mock.copyWith(image: 'assets/image/cat.jpg'),
                  ModelResolverController<List<Playlist>>(),
                );
              },
            );
          },
        ),
      ),
    );
  });

  tearDownAll(() => kiwiContainer.clear());

  Future<void> pumpAndDisplayContextMenu(WidgetTester tester) async {
    await tester.pumpWidget(widget);
    await tester.tap(find.byKey(key), buttons: kSecondaryButton);
    await tester.pumpAndSettle();
  }

  void expectCalls() {
    for (final value in PlaylistListingPlaylistMenuEnum.values) {
      expect(find.byIcon(value.icon), findsOneWidget);
      expect(find.text(value.text), findsOneWidget);
    }
  }

  testWidgets(
    'PlaylistListingPlaylistMenuEnum.renamePlaylist widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(PlaylistListingPlaylistMenuEnum.renamePlaylist.text));
      await tester.pump();
      expect(find.byType(RenamePlaylistModal), findsOneWidget);
    },
  );

  testWidgets(
    'PlaylistListingPlaylistMenuEnum.setPlaylistImage widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(PlaylistListingPlaylistMenuEnum.setPlaylistImage.text));
    },
  );

  testWidgets(
    'PlaylistListingPlaylistMenuEnum.setPlaylistImage widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(PlaylistListingPlaylistMenuEnum.removePlaylistImage.text));
    },
  );

  testWidgets(
    'PlaylistListingPlaylistMenuEnum.deletePlaylistFromMyoroPlayer widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(PlaylistListingPlaylistMenuEnum.deletePlaylistFromMyoroPlayer.text));
    },
  );

  testWidgets(
    'PlaylistListingPlaylistMenuEnum.deletePlaylistFromComputer widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(PlaylistListingPlaylistMenuEnum.deletePlaylistFromComputer.text));
    },
  );
}
