import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/widgets/buttons/icon_without_feedback_button.dart';

import '../../base_test_widget.dart';

void main() {
  testWidgets('IconWithoutFeedbackButton Widget Test', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        testType: TestTypeEnum.widget,
        child: IconWithoutFeedbackButton(
          onTap: () {},
          icon: Icons.abc,
          iconSize: Random().nextDouble() * 100,
        ),
      ),
    );

    expect(find.byType(IconWithoutFeedbackButton), findsOneWidget);
    expect(find.byType(InkWell), findsOneWidget);
    expect(find.byType(Padding), findsOneWidget);
    expect(find.byType(Icon), findsOneWidget);
  });
}
