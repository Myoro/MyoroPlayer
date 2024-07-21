import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/core/design_system/color_design_system.dart';
import 'package:myoro_player/core/widgets/dividers/basic_divider.dart';

import '../../../base_test_widget.dart';

void main() {
  void expectCalls() {
    expect(find.byType(BasicDivider), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is Padding && w.padding == EdgeInsets.zero && w.child is Container && (w.child as Container).color == DarkModeColorDesignSystem.onBackground,
      ),
      findsOneWidget,
    );
  }

  testWidgets('Horizontal BasicDivider widget test.', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        themeMode: ThemeMode.dark,
        child: BasicDivider(
          direction: Axis.horizontal,
        ),
      ),
    );

    expectCalls();
  });

  testWidgets('Vertical BasicDivider widget test.', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        child: BasicDivider(
          direction: Axis.vertical,
        ),
      ),
    );

    expectCalls();
  });
}
