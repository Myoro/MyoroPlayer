import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/desktop/main_screen/enums/main_screen_app_bar_drawer_items_enum.dart';
import 'package:frontend/desktop/main_screen/widgets/main_screen_app_bar/main_screen_app_bar_drawer.dart';
import 'package:frontend/main.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:frontend/shared/widgets/scrollbars/vertical_scrollbar.dart';

// TODO: Redo this text to display the drawer with the static method show
void main() {
  testWidgets('MainScreenAppBarDrawer Widget Test', (tester) async {
    await tester.pumpWidget(App());

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pump();

    expect(find.byType(MainScreenAppBarDrawer), findsOneWidget);

    expect(
      find.byWidgetPredicate(
        (w) => w is Expanded && w.child is VerticalScrollbar && (w.child as VerticalScrollbar).children.length == MainScreenAppBarDrawerItemsEnum.values.length,
      ),
      findsOneWidget,
    );

    for (final item in MainScreenAppBarDrawerItemsEnum.values) {
      expect(
        find.byWidgetPredicate((w) => (w is IconTextHoverButton &&
            w.padding == const EdgeInsets.symmetric(horizontal: 10, vertical: 5) &&
            w.icon == item.icon &&
            w.iconSize == ImageSizeEnum.small.size &&
            w.text == item.text)),
        findsOneWidget,
      );
    }
  });
}
