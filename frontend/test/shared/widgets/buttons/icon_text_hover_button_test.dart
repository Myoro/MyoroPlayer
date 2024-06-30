import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/widgets/buttons/base_hover_button.dart';
import 'package:frontend/shared/widgets/buttons/icon_text_hover_button.dart';

import '../../../base_test_widget.dart';

void main() {
  final buttonFinder = find.byType(IconTextHoverButton);
  const icon = Icons.abc;
  final double iconSize = ImageSizeEnum.small.size;
  const text = 'Text';

  testWidgets('IconTextHoverButton widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        themeMode: ThemeMode.dark,
        child: IconTextHoverButton(
          icon: icon,
          iconSize: iconSize,
          text: text,
          onTap: () => print('IconTextHoverButton [onTap] working.'),
          onSecondaryTapDown: (_) => print('IconTextHoverButton [onSecondaryTapDown] working.'),
        ),
      ),
    );

    expect(buttonFinder, findsOneWidget);
    expect(find.byWidgetPredicate((w) => w is BaseHoverButton && w.padding == const EdgeInsets.all(3)), findsOneWidget);
    expect(
      find.byWidgetPredicate((w) => (w is Row &&
          w.children.length == 3 &&
          w.children.first is Icon &&
          w.children[1] is SizedBox &&
          (w.children[1] as SizedBox).width == 10 &&
          w.children.last is Expanded)),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (w) => w is Icon && w.icon == Icons.abc && w.size == iconSize && w.color == DarkModeColorDesignSystem.onBackground,
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate((w) => (w is Expanded &&
          w.child is Text &&
          (w.child as Text).maxLines == 1 &&
          (w.child as Text).overflow == TextOverflow.ellipsis &&
          (w.child as Text).data == text)),
      findsOneWidget,
    );

    await tester.tap(buttonFinder);
    await tester.tap(buttonFinder, buttons: kSecondaryButton);
  });
}
