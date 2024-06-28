import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/widgets/buttons/no_feedback_button.dart';

import '../../../base_test_widget.dart';

void main() {
  const text = 'Text';

  testWidgets('NoFeedbackButton widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        child: NoFeedbackButton(
          onTap: () => print('NoFeedbackButton [onTap] working.'),
          child: const Text(text),
        ),
      ),
    );

    expect(
      find.byWidgetPredicate((w) => (w is InkWell &&
          w.hoverColor == ColorDesignSystem.transparent &&
          w.splashColor == ColorDesignSystem.transparent &&
          w.highlightColor == ColorDesignSystem.transparent &&
          w.child is Text &&
          (w.child as Text).data == text)),
      findsOneWidget,
    );

    await tester.tap(find.byType(NoFeedbackButton));
  });
}
