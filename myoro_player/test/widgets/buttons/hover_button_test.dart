import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/design_system/svg_design_system.dart';
import 'package:myoro_player/widgets/buttons/hover_button.dart';
import 'package:myoro_player/widgets/icons/base_svg.dart';

import '../../base_test_widget.dart';

void main() {
  testWidgets('HoverButton Widget Test', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        testType: TestTypeEnum.widget,
        child: Column(
          children: [
            HoverButton(
              onTap: () => {},
              icon: Icons.abc,
              iconSize: Random().nextDouble() * 100,
            ),
            HoverButton(
              onTap: () => {},
              svgPath: SvgDesignSystem.logo,
              iconSize: Random().nextDouble() * 100,
            ),
            HoverButton(onTap: () => {}, text: 'HoverButton #3 Text'),
            HoverButton(
              onTap: () => {},
              icon: Icons.abc,
              iconSize: Random().nextDouble() * 100,
              text: 'HoverButton #4 Text',
            ),
            HoverButton(
              onTap: () => {},
              svgPath: SvgDesignSystem.logo,
              iconSize: Random().nextDouble() * 100,
              text: 'HoverButton #5 Text',
            ),
          ],
        ),
      ),
    );

    expect(find.byType(HoverButton), findsNWidgets(5));
    expect(find.byType(InkWell), findsNWidgets(5));
    expect(find.byType(Container), findsNWidgets(5));
    expect(find.byType(Padding), findsNWidgets(10));
    expect(find.byType(Row), findsNWidgets(5));
    expect(find.byType(Icon), findsNWidgets(2));
    expect(find.byType(BaseSvg), findsNWidgets(2));
    expect(find.byType(Expanded), findsNWidgets(3));
    expect(find.byType(SizedBox), findsNWidgets(7));
    expect(find.byType(Text), findsNWidgets(3));
    expect(find.text('HoverButton #3 Text'), findsOneWidget);
    expect(find.text('HoverButton #4 Text'), findsOneWidget);
    expect(find.text('HoverButton #5 Text'), findsOneWidget);
  });
}
