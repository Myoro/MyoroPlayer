import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/design_system/decoration_design_system.dart';
import 'package:frontend/shared/widgets/dividers/basic_divider.dart';
import 'package:frontend/shared/widgets/dividers/resize_divider.dart';

import '../../../base_test_widget.dart';

void main() {
  final dividerFinder = find.byType(ResizeDivider);

  void expectCalls(Axis direction) {
    final bool isHorizontal = direction == Axis.horizontal;

    expect(find.byType(ResizeDivider), findsOneWidget);

    expect(
      find.byWidgetPredicate(
        (w) =>
            w is Stack &&
            w.alignment == Alignment.center &&
            w.children.length == 2 &&
            w.children.first is Positioned &&
            w.children.last is IgnorePointer,
      ),
      findsOneWidget,
    );

    expect(
        find.byWidgetPredicate((w) => w is Positioned && w.child is MouseRegion), findsOneWidget);

    expect(
      find.byWidgetPredicate(
        (w) =>
            w is MouseRegion &&
            w.cursor ==
                (isHorizontal ? SystemMouseCursors.resizeRow : SystemMouseCursors.resizeColumn) &&
            w.child is GestureDetector,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => w is GestureDetector && w.child is Container),
      findsAtLeastNWidgets(1),
    );

    expect(
      find.byWidgetPredicate((w) => (w is Container &&
          w.decoration ==
              BoxDecoration(
                color: DarkModeColorDesignSystem.onBackground,
                borderRadius: DecorationDesignSystem.borderRadius,
              ))),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => (w is IgnorePointer &&
          w.child is Padding &&
          (w.child as Padding).padding == EdgeInsets.zero &&
          (w.child as Padding).child is BasicDivider &&
          ((w.child as Padding).child as BasicDivider).direction == direction)),
      findsOneWidget,
    );
  }

  testWidgets('Horizontal ResizeDivider widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        themeMode: ThemeMode.dark,
        child: ResizeDivider(
          direction: Axis.horizontal,
          resizeCallback: (details) => print(details),
        ),
      ),
    );

    expectCalls(Axis.horizontal);
    await tester.drag(dividerFinder, const Offset(50, 0));
  });

  testWidgets('Vertical ResizeDivider widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        child: ResizeDivider(
          direction: Axis.vertical,
          resizeCallback: (details) => print(details),
        ),
      ),
    );

    expectCalls(Axis.vertical);
    await tester.drag(dividerFinder, const Offset(0, 50));
  });
}
