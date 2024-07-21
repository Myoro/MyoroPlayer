import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/core/widgets/sliders/base_slider.dart';

import '../../../base_test_widget.dart';

void main() {
  const double width = 300;
  const double max = 100;
  const double value = 50;

  testWidgets('BaseSlider widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        child: BaseSlider(
          width: width,
          max: 100,
          value: 50,
          onChanged: (value) {
            if (kDebugMode) {
              print('BaseSlider\'s value: $value');
            }
          },
        ),
      ),
    );

    expect(find.byType(BaseSlider), findsOneWidget);

    expect(
      find.byWidgetPredicate((w) => w is SizedBox && w.width == width && w.height == 25 && w.child is Slider),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => w is Slider && w.min == 0 && w.max == max && w.value == value),
      findsOneWidget,
    );

    await tester.drag(find.byType(Slider), const Offset(50, 0));
  });
}
