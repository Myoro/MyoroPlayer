import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/main_screen/enums/main_screen_body_playlist_side_bar_context_menu_enum.dart';

import '../../../base_test_widget.dart';

void main() {
  const key = Key('');

  testWidgets('MainScreenBodyPlaylistSideBarContextMenuEnum widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        child: Builder(
          builder: (context) {
            return GestureDetector(
              key: key,
              onSecondaryTapDown: (details) {
                MainScreenBodyPlaylistSideBarContextMenuEnum.showContextMenu(
                  context,
                  details,
                );
              },
            );
          },
        ),
      ),
    );

    await tester.tap(find.byKey(key), buttons: kSecondaryButton);
    await tester.pump();

    for (final value in MainScreenBodyPlaylistSideBarContextMenuEnum.values) {
      expect(find.byIcon(value.icon), findsOneWidget);
      expect(find.text(value.text), findsOneWidget);
    }
  });
}
