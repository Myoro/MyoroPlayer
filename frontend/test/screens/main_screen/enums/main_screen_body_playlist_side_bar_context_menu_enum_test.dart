import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/main_screen/enums/main_screen_body_playlist_side_bar_context_menu_enum.dart';
import 'package:frontend/shared/controllers/model_resolver_controller.dart';
import 'package:frontend/shared/models/playlist.dart';
import 'package:frontend/shared/widgets/modals/rename_playlist_modal.dart';

import '../../../base_test_widget.dart';

void main() {
  const key = Key('');

  final Widget widget = BaseTestWidget(
    child: Builder(
      builder: (context) {
        return GestureDetector(
          key: key,
          onSecondaryTapDown: (details) {
            MainScreenBodyPlaylistSideBarContextMenuEnum.showContextMenu(
              context,
              details,
              Playlist.mock,
              ModelResolverController<List<Playlist>>(),
            );
          },
        );
      },
    ),
  );

  Future<void> expectCalls(WidgetTester tester) async {
    await tester.tap(find.byKey(key), buttons: kSecondaryButton);
    await tester.pumpAndSettle();

    for (final value in MainScreenBodyPlaylistSideBarContextMenuEnum.values) {
      expect(find.byIcon(value.icon), findsOneWidget);
      expect(find.text(value.text), findsOneWidget);
    }
  }

  testWidgets(
    'MainScreenBodyPlaylistSideBarContextMenuEnum.renamePlaylist widget test.',
    (tester) async {
      await tester.pumpWidget(widget);
      await expectCalls(tester);
      await tester.tap(find.text(MainScreenBodyPlaylistSideBarContextMenuEnum.renamePlaylist.text));
      await tester.pump();
      expect(find.byType(RenamePlaylistModal), findsOneWidget);
    },
  );

  testWidgets(
    'MainScreenBodyPlaylistSideBarContextMenuEnum.setPlaylistImage widget test.',
    (tester) async {
      await tester.pumpWidget(widget);
      await expectCalls(tester);
      await tester.tap(find.text(MainScreenBodyPlaylistSideBarContextMenuEnum.setPlaylistImage.text));
      expect(tester.takeException(), isInstanceOf<UnimplementedError>());
    },
  );

  testWidgets(
    'MainScreenBodyPlaylistSideBarContextMenuEnum.deletePlaylistFromMyoroPlayer widget test.',
    (tester) async {
      await tester.pumpWidget(widget);
      await expectCalls(tester);
      await tester.tap(find.text(MainScreenBodyPlaylistSideBarContextMenuEnum.deletePlaylistFromMyoroPlayer.text));
      expect(tester.takeException(), isInstanceOf<UnimplementedError>());
    },
  );

  testWidgets(
    'MainScreenBodyPlaylistSideBarContextMenuEnum.deletePlaylistFromComputer widget test.',
    (tester) async {
      await tester.pumpWidget(widget);
      await expectCalls(tester);
      await tester.tap(find.text(MainScreenBodyPlaylistSideBarContextMenuEnum.deletePlaylistFromComputer.text));
      expect(tester.takeException(), isInstanceOf<UnimplementedError>());
    },
  );
}
