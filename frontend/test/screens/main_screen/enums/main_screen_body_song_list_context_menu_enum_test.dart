import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/main_screen/enums/main_screen_body_song_list_context_menu_enum.dart';
import 'package:frontend/shared/models/song.dart';

import '../../../base_test_widget.dart';

void main() {
  final key = UniqueKey();

  final widget = BaseTestWidget(
    child: Builder(
      builder: (context) {
        return GestureDetector(
          key: key,
          onTap: () {
            MainScreenBodySongListContextMenuEnum.showContextMenu(
              context,
              TapDownDetails(),
              Song.mock,
            );
          },
        );
      },
    ),
  );

  Future<void> pumpAndDisplayContextMenu(WidgetTester tester) async {
    await tester.pumpWidget(widget);
    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle();
  }

  void expectCalls() {
    for (final value in MainScreenBodySongListContextMenuEnum.values) {
      expect(find.byIcon(value.icon), findsOneWidget);
      expect(find.text(value.text), findsOneWidget);
    }
  }

  testWidgets(
    'MainScreenBodySongListContextMenuEnum.addToQueue widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(MainScreenBodySongListContextMenuEnum.addToQueue.text));
      expect(tester.takeException(), isInstanceOf<UnimplementedError>());
    },
  );

  testWidgets(
    'MainScreenBodySongListContextMenuEnum.copySongToPlaylist widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(MainScreenBodySongListContextMenuEnum.copySongToPlaylist.text));
      expect(tester.takeException(), isInstanceOf<UnimplementedError>());
    },
  );

  testWidgets(
    'MainScreenBodySongListContextMenuEnum.addToQueue widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(MainScreenBodySongListContextMenuEnum.moveSongToPlaylist.text));
      expect(tester.takeException(), isInstanceOf<UnimplementedError>());
    },
  );

  testWidgets(
    'MainScreenBodySongListContextMenuEnum.addToQueue widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(MainScreenBodySongListContextMenuEnum.deleteSong.text));
      expect(tester.takeException(), isInstanceOf<UnimplementedError>());
    },
  );
}
