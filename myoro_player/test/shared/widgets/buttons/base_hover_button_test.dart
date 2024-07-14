import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/design_system/decoration_design_system.dart';
import 'package:myoro_player/shared/widgets/buttons/base_hover_button.dart';

import '../../../base_test_widget.dart';

void main() {
  final baseHoverButtonFinder = find.byType(BaseHoverButton);
  const text = 'Text';

  testWidgets('BaseHoverButton widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        themeMode: ThemeMode.dark,
        child: BaseHoverButton(
          bordered: true,
          onTap: () {
            if (kDebugMode) {
              print('BaseHoverButton [onTap] working.');
            }
          },
          onSecondaryTapDown: (_) {
            if (kDebugMode) {
              print('BaseHoverButton [onSecondaryTapDown] working.');
            }
          },
          builder: (_) {
            return const Text(text);
          },
        ),
      ),
    );

    expect(baseHoverButtonFinder, findsOneWidget);
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
          w.padding == EdgeInsets.zero &&
          w.decoration ==
              BoxDecoration(
                borderRadius: DecorationDesignSystem.borderRadius,
                color: DarkModeColorDesignSystem.background,
                border: Border.all(
                  width: 2,
                  color: DarkModeColorDesignSystem.onBackground,
                ),
              ) &&
          w.child is Text &&
          (w.child as Text).data == text)),
      findsOneWidget,
    );

    await tester.tap(baseHoverButtonFinder);
    await tester.tap(baseHoverButtonFinder, buttons: kSecondaryButton);
  });
}
