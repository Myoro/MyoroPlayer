import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_bloc.dart';
import 'package:myoro_player/desktop/screens/main_screen/enums/main_screen_body_playlist_side_bar_context_menu_enum.dart';
import 'package:myoro_player/shared/controllers/model_resolver_controller.dart';
import 'package:myoro_player/shared/helpers/file_system_helper.dart';
import 'package:myoro_player/shared/models/playlist.dart';
import 'package:myoro_player/shared/services/playlist_service/playlist_service.dart';
import 'package:myoro_player/shared/widgets/modals/rename_playlist_modal.dart';
import 'package:kiwi/kiwi.dart';

import '../../../../base_test_widget.dart';
import '../../../../mocks/file_system_helper_mock.dart';
import '../../../../mocks/playlist_service_mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();
  late final MainScreenBodyPlaylistSideBarBloc mainScreenBodyPlaylistSideBarBloc;
  const key = Key('');
  late final Widget widget;

  setUpAll(() {
    kiwiContainer
      ..registerFactory<FileSystemHelper>((_) => FileSystemHelperMock.preConfigured())
      ..registerFactory<PlaylistService>((_) => PlaylistServiceMock.preConfigured());

    mainScreenBodyPlaylistSideBarBloc = MainScreenBodyPlaylistSideBarBloc();

    widget = BaseTestWidget(
      child: BlocProvider.value(
        value: mainScreenBodyPlaylistSideBarBloc,
        child: Builder(
          builder: (context) {
            return GestureDetector(
              key: key,
              onSecondaryTapDown: (details) {
                MainScreenBodyPlaylistSideBarContextMenuEnum.showContextMenu(
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
    for (final value in MainScreenBodyPlaylistSideBarContextMenuEnum.values) {
      expect(find.byIcon(value.icon), findsOneWidget);
      expect(find.text(value.text), findsOneWidget);
    }
  }

  testWidgets(
    'MainScreenBodyPlaylistSideBarContextMenuEnum.renamePlaylist widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(MainScreenBodyPlaylistSideBarContextMenuEnum.renamePlaylist.text));
      await tester.pump();
      expect(find.byType(RenamePlaylistModal), findsOneWidget);
    },
  );

  testWidgets(
    'MainScreenBodyPlaylistSideBarContextMenuEnum.setPlaylistImage widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(MainScreenBodyPlaylistSideBarContextMenuEnum.setPlaylistImage.text));
    },
  );

  testWidgets(
    'MainScreenBodyPlaylistSideBarContextMenuEnum.setPlaylistImage widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(MainScreenBodyPlaylistSideBarContextMenuEnum.removePlaylistImage.text));
    },
  );

  testWidgets(
    'MainScreenBodyPlaylistSideBarContextMenuEnum.deletePlaylistFromMyoroPlayer widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(MainScreenBodyPlaylistSideBarContextMenuEnum.deletePlaylistFromMyoroPlayer.text));
    },
  );

  testWidgets(
    'MainScreenBodyPlaylistSideBarContextMenuEnum.deletePlaylistFromComputer widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(MainScreenBodyPlaylistSideBarContextMenuEnum.deletePlaylistFromComputer.text));
    },
  );
}