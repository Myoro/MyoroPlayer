import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/desktop/main_screen/widgets/main_screen_body/main_screen_body.dart';
import 'package:frontend/desktop/main_screen/widgets/main_screen_body/main_screen_body_footer.dart';
import 'package:frontend/desktop/main_screen/widgets/main_screen_body/main_screen_body_playlist_side_bar.dart';
import 'package:frontend/desktop/main_screen/widgets/main_screen_body/main_screen_body_song_list.dart';
import 'package:frontend/shared/widgets/dividers/basic_divider.dart';

import '../../../../base_test_widget.dart';

void main() {
  testWidgets('MainScreenBody Widget Test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        child: MainScreenBody(),
      ),
    );

    expect(
      find.byWidgetPredicate(
        (w) => w is Row && w.children.length == 2 && w.children.first is MainScreenBodyPlaylistSideBar && w.children.last is Expanded,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => w is Expanded && w.child is Column),
      findsAtLeastNWidgets(1),
    );

    expect(
      find.byWidgetPredicate((w) => (w is Column &&
          w.children.length == 3 &&
          w.children.first is MainScreenBodySongList &&
          w.children[1] is BasicDivider &&
          (w.children[1] as BasicDivider).direction == Axis.horizontal &&
          w.children.last is MainScreenBodyFooter)),
      findsOneWidget,
    );
  });
}
