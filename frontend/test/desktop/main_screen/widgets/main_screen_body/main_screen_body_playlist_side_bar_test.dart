import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/desktop/main_screen/widgets/main_screen_body/main_screen_body_playlist_side_bar.dart';
import 'package:frontend/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:frontend/shared/widgets/dividers/resize_divider.dart';
import 'package:frontend/shared/widgets/titles/underline_title.dart';

import '../../../../base_test_widget.dart';

void main() {
  testWidgets('MainScreenBodyPlaylistSideBar Widget Test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        child: MainScreenBodyPlaylistSideBar(),
      ),
    );

    expect(find.byType(MainScreenBodyPlaylistSideBar), findsOneWidget);
    expect(find.byType(ValueListenableBuilder<double>), findsOneWidget);

    expect(
      find.byWidgetPredicate(
        (w) => w is Container && w.constraints?.minWidth == 173 && w.child is Row,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (w) => w is Row && w.children.length == 2 && w.children.last is ResizeDivider,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => w is Expanded && w.child is Column),
      findsAtLeastNWidgets(1),
    );

    expect(
      find.byWidgetPredicate((w) => (w is Column &&
          w.children.length == 2 &&
          w.children.first is UnderlineTitle &&
          (w.children.first as UnderlineTitle).text == 'Playlists' &&
          w.children.last is Expanded)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => (w is Expanded &&
          w.child is Scrollbar &&
          (w.child as Scrollbar).thumbVisibility == true &&
          (w.child as Scrollbar).child is SingleChildScrollView &&
          ((w.child as Scrollbar).child as SingleChildScrollView).child is Padding &&
          (((w.child as Scrollbar).child as SingleChildScrollView).child as Padding).padding == const EdgeInsets.symmetric(horizontal: 12) &&
          (((w.child as Scrollbar).child as SingleChildScrollView).child as Padding).child is Column)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (w) => w is Column && w.children.length == 50 * 2 + 1 && w.children.last is SizedBox && (w.children.last as SizedBox).height == 5,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => (w is IconTextHoverButton &&
          w.padding == const EdgeInsets.symmetric(horizontal: 10, vertical: 5) &&
          w.icon == Icons.music_note &&
          w.text == 'Playlist name')),
      findsNWidgets(50),
    );

    expect(
      find.byWidgetPredicate(
        (w) => w is ResizeDivider && w.direction == Axis.vertical && w.padding == const EdgeInsets.only(top: 40, bottom: 10),
      ),
      findsOneWidget,
    );
  });
}
