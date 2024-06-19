import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/design_system/decoration_design_system.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:frontend/shared/widgets/drawers/base_drawer.dart';

import '../../../base_test_widget.dart';

void main() {
  testWidgets('BaseDrawer Widget Test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        themeMode: ThemeMode.dark,
        child: BaseDrawer(
          title: 'Title',
          child: Text('Drawer content'),
        ),
      ),
    );

    expect(find.byType(BaseDrawer), findsOneWidget);

    expect(
      find.byWidgetPredicate(
        (w) => w is Padding && w.padding == const EdgeInsets.all(5) && w.child is Drawer,
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
          w.child is Padding)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (w) => w is Padding && w.padding == const EdgeInsets.all(10) && w.child is Column,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (w) =>
            w is Column && w.children.length == 2 && w.children.first is Row && w.children.last is Text && (w.children.last as Text).data == 'Drawer content',
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => (w is Row &&
          w.children.length == 3 &&
          w.children.first is Text &&
          (w.children.first as Text).data == 'Title' &&
          w.children[1] is Spacer &&
          w.children.last is IconTextHoverButton &&
          (w.children.last as IconTextHoverButton).icon == Icons.close &&
          (w.children.last as IconTextHoverButton).iconSize == ImageSizeEnum.small.size)),
      findsOneWidget,
    );
  });
}
