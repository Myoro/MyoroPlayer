import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/design_system/svg_design_system.dart';
import 'package:myoro_player/widgets/icons/base_svg.dart';

import '../../base_test_widget.dart';

void main() {
  testWidgets('BaseSvg Widget Test', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        testType: TestTypeEnum.widget,
        child: BaseSvg(
          svgPath: SvgDesignSystem.logo,
          svgSize: Random().nextDouble() * 100,
          svgColor: Colors.pink,
        ),
      ),
    );

    expect(find.byType(BaseSvg), findsOneWidget);
    expect(find.byType(SvgPicture), findsOneWidget);
  });
}
