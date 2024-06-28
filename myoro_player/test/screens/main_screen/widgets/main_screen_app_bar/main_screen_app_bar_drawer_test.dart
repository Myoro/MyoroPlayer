import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/screens/main_screen/enums/main_screen_app_bar_drawer_items_enum.dart';
import 'package:myoro_player/screens/main_screen/widgets/main_screen_app_bar/main_screen_app_bar_drawer.dart';
import 'package:myoro_player/shared/enums/image_size_enum.dart';
import 'package:myoro_player/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:myoro_player/shared/widgets/scrollbars/vertical_scrollbar.dart';

import '../../../../base_test_widget.dart';

void main() {
  const key = Key('');

  testWidgets('MainScreenAppBarDrawer widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        child: Builder(
          builder: (context) {
            return GestureDetector(
              key: key,
              onTap: () {
                MainScreenAppBarDrawer.show(context);
              },
            );
          },
        ),
      ),
    );

    await tester.tap(find.byKey(key));
    await tester.pump();

    expect(find.byType(MainScreenAppBarDrawer), findsOneWidget);

    expect(
      find.byWidgetPredicate((w) => (w is Expanded &&
          w.child is VerticalScrollbar &&
          (w.child as VerticalScrollbar).children.length ==
              MainScreenAppBarDrawerItemsEnum.values.length)),
      findsOneWidget,
    );

    for (final value in MainScreenAppBarDrawerItemsEnum.values) {
      expect(
        find.byWidgetPredicate((w) => (w is IconTextHoverButton &&
            w.icon == value.icon &&
            w.iconSize == ImageSizeEnum.small.size &&
            w.text == value.text &&
            w.padding == const EdgeInsets.all(5))),
        findsOneWidget,
      );
    }
  });
}
