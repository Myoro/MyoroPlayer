import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/design_system/decoration_design_system.dart';
import 'package:frontend/shared/widgets/buttons/base_hover_button.dart';

import '../../../base_test_widget.dart';

void main() {
  testWidgets('BaseHoverButton Widget Test', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        child: BaseHoverButton(
          padding: const EdgeInsets.all(10),
          builder: (hovered) => const Text('Text'),
          onTap: () => print('onTap Working'),
        ),
      ),
    );

    expect(find.byType(BaseHoverButton), findsOneWidget);

    expect(
      find.byWidgetPredicate((w) => (w is InkWell &&
          w.hoverColor == ColorDesignSystem.transparent &&
          w.splashColor == ColorDesignSystem.transparent &&
          w.highlightColor == ColorDesignSystem.transparent &&
          w.child is ValueListenableBuilder<bool>)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => (w is Container &&
          w.padding == const EdgeInsets.all(10) &&
          w.decoration ==
              BoxDecoration(
                color: ColorDesignSystem.transparent,
                borderRadius: DecorationDesignSystem.borderRadius,
              ) &&
          w.child is Text &&
          (w.child as Text).data == 'Text')),
      findsOneWidget,
    );

    await tester.tap(find.byType(BaseHoverButton));
  });
}
