import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/design_system/decoration_design_system.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:frontend/shared/widgets/drawers/base_drawer.dart';

import '../../../base_test_widget.dart';

void main() {
  const title = 'Title';
  const drawerContent = SizedBox.shrink();

  testWidgets('BaseDrawer widget test.', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        themeMode: ThemeMode.dark,
        child: BaseDrawer(
          title: title,
          child: drawerContent,
        ),
      ),
    );

    expect(find.byType(BaseDrawer), findsOneWidget);

    expect(
      find.byWidgetPredicate(
        (w) => w is Padding && w.padding == const EdgeInsets.all(10) && w.child is Row,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => (w is Row &&
          w.mainAxisAlignment == MainAxisAlignment.end &&
          w.children.length == 3 &&
          w.children.first is IconTextHoverButton &&
          w.children[1] is SizedBox &&
          (w.children[1] as SizedBox).width == 10 &&
          w.children.last is Drawer)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (w) => w is IconTextHoverButton && w.icon == Icons.arrow_right && w.iconSize == ImageSizeEnum.small.size && w.bordered,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => (w is Drawer &&
          w.shape ==
              RoundedRectangleBorder(
                borderRadius: DecorationDesignSystem.borderRadius,
                side: const BorderSide(
                  width: 2,
                  color: DarkModeColorDesignSystem.onBackground,
                ),
              ) &&
          w.child is Padding &&
          (w.child as Padding).padding == const EdgeInsets.symmetric(vertical: 10) &&
          (w.child as Padding).child is Column)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => (w is Column &&
          w.children.length == 3 &&
          w.children.first is Text &&
          w.children[1] is SizedBox &&
          (w.children[1] as SizedBox).height == 2 &&
          w.children.last == drawerContent)),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.arrow_right));
  });
}
