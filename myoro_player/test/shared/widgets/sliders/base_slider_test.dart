import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/shared/widgets/sliders/base_slider.dart';

import '../../../base_test_widget.dart';

void main() {
  const double width = 300;

  testWidgets('BaseSlider widget test.', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        child: BaseSlider(
          width: width,
        ),
      ),
    );

    expect(find.byType(BaseSlider), findsOneWidget);

    expect(
      find.byWidgetPredicate(
          (w) => w is SizedBox && w.width == width && w.height == 25 && w.child is Slider),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => w is Slider && w.min == 0 && w.max == 100 && w.value == 50),
      findsOneWidget,
    );

    await tester.drag(find.byType(Slider), const Offset(50, 0));
  });
}
