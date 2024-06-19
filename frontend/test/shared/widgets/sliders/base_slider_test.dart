import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/widgets/sliders/base_slider.dart';

import '../../../base_test_widget.dart';

void main() {
  testWidgets('BaseSlider Widget Test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        child: BaseSlider(
          width: 500,
        ),
      ),
    );

    expect(find.byType(BaseSlider), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is SizedBox && w.width == 500 && w.height == 25 && w.child is Slider,
      ),
      findsOneWidget,
    );
  });
}
