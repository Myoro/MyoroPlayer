import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/design_system/decoration_design_system.dart';
import 'package:frontend/shared/widgets/dividers/basic_divider.dart';

import '../../../base_test_widget.dart';

void main() {
  void expectCalls({
    required Axis direction,
    EdgeInsets? padding,
  }) {
    final bool isHorizontal = direction == Axis.horizontal;

    expect(find.byType(BasicDivider), findsOneWidget);

    expect(
      find.byWidgetPredicate((w) => (w is Padding &&
          w.padding ==
              (padding ??
                  EdgeInsets.symmetric(
                    horizontal: isHorizontal ? 10 : 0,
                    vertical: isHorizontal ? 0 : 10,
                  )) &&
          w.child is Container)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => (w is Container &&
          w.decoration ==
              BoxDecoration(
                color: DarkModeColorDesignSystem.onBackground,
                borderRadius: DecorationDesignSystem.borderRadius,
              ))),
      findsOneWidget,
    );
  }

  testWidgets('Horizontal BasicDivider Widget Test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        themeMode: ThemeMode.dark,
        child: BasicDivider(
          direction: Axis.horizontal,
        ),
      ),
    );

    expectCalls(
      direction: Axis.horizontal,
    );
  });

  testWidgets('Horizontal BasicDivider Widget Test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        child: BasicDivider(
          direction: Axis.vertical,
          padding: EdgeInsets.all(10),
          customSize: 50,
        ),
      ),
    );

    expectCalls(
      direction: Axis.vertical,
      padding: const EdgeInsets.all(10),
    );
  });
}
