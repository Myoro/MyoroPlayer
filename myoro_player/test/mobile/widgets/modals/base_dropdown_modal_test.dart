import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/core/design_system/color_design_system.dart';
import 'package:myoro_player/core/enums/image_size_enum.dart';
import 'package:myoro_player/core/models/menu_item.dart';
import 'package:myoro_player/core/widgets/buttons/no_feedback_button.dart';
import 'package:myoro_player/core/widgets/dividers/basic_divider.dart';
import 'package:myoro_player/mobile/widgets/modals/base_dropdown_modal.dart';

import '../../../base_test_widget.dart';

void main() {
  final items = List.generate(
    10,
    (index) => MenuItem.fake(
      onTap: () {
        if (kDebugMode) {
          print(index);
        }
      },
    ),
  );

  testWidgets('BaseDropdownModal widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        themeMode: ThemeMode.dark,
        child: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                BaseDropdownModal.show(
                  context,
                  items,
                );
              },
            );
          },
        ),
      ),
    );

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    expect(find.byType(BaseDropdownModal), findsOneWidget);

    expect(
      find.byWidgetPredicate((w) => (w is Align &&
          w.alignment == Alignment.bottomCenter &&
          w.child is Column &&
          (w.child as Column).mainAxisSize == MainAxisSize.min &&
          (w.child as Column).mainAxisAlignment == MainAxisAlignment.end &&
          (w.child as Column).children.length == 2 &&
          (w.child as Column).children.first is BasicDivider &&
          ((w.child as Column).children.first as BasicDivider).direction == Axis.horizontal &&
          (w.child as Column).children.last is Material &&
          ((w.child as Column).children.last as Material).color == DarkModeColorDesignSystem.background &&
          ((w.child as Column).children.last as Material).child is Column &&
          (((w.child as Column).children.last as Material).child as Column).mainAxisSize == MainAxisSize.min &&
          (((w.child as Column).children.last as Material).child as Column).children.length == items.length)),
      findsOneWidget,
    );

    for (final item in items) {
      expect(
        find.byWidgetPredicate((w) => (w is NoFeedbackButton &&
            w.child is Padding &&
            (w.child as Padding).padding == const EdgeInsets.all(10) &&
            (w.child as Padding).child is Row &&
            ((w.child as Padding).child as Row).children.length == 3 &&
            ((w.child as Padding).child as Row).children.first is Icon &&
            (((w.child as Padding).child as Row).children.first as Icon).icon == item.icon &&
            (((w.child as Padding).child as Row).children.first as Icon).size == ImageSizeEnum.small.size &&
            (((w.child as Padding).child as Row).children.first as Icon).color == DarkModeColorDesignSystem.onBackground &&
            ((w.child as Padding).child as Row).children[1] is SizedBox &&
            (((w.child as Padding).child as Row).children[1] as SizedBox).width == 10 &&
            ((w.child as Padding).child as Row).children.last is Expanded &&
            (((w.child as Padding).child as Row).children.last as Expanded).child is Text &&
            ((((w.child as Padding).child as Row).children.last as Expanded).child as Text).data == item.text)),
        findsOneWidget,
      );
    }
  });
}
