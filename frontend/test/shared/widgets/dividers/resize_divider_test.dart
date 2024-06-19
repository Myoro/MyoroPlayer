import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/design_system/decoration_design_system.dart';
import 'package:frontend/shared/widgets/dividers/basic_divider.dart';
import 'package:frontend/shared/widgets/dividers/resize_divider.dart';

import '../../../base_test_widget.dart';

void main() {
  void expectCalls({
    required Axis direction,
    required MouseCursor cursor,
    EdgeInsets? padding,
  }) {
    expect(find.byType(ResizeDivider), findsOneWidget);

    expect(
      find.byWidgetPredicate(
        (w) => w is Stack && w.alignment == Alignment.center && w.children.length == 2 && w.children.first is Positioned && w.children.last is IgnorePointer,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => w is Positioned && w.child is MouseRegion),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => w is MouseRegion && w.cursor == cursor && w.child is GestureDetector),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => w is GestureDetector && w.child is Container),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (w) => (w is Container &&
            w.decoration ==
                BoxDecoration(
                  color: DarkModeColorDesignSystem.onBackground,
                  borderRadius: DecorationDesignSystem.borderRadius,
                )),
      ),
      findsNWidgets(2),
    );

    expect(
      find.byWidgetPredicate((w) => w is IgnorePointer && w.child is BasicDivider),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => w is BasicDivider && w.direction == direction && w.padding == padding),
      findsOneWidget,
    );
  }

  testWidgets('Horizontal ResizeDivider Widget Test', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        child: ResizeDivider(
          direction: Axis.horizontal,
          onVerticalDragUpdate: (_) {},
          padding: const EdgeInsets.all(10),
        ),
      ),
    );

    expectCalls(
      direction: Axis.horizontal,
      cursor: SystemMouseCursors.resizeRow,
      padding: const EdgeInsets.all(10),
    );
  });

  testWidgets('Horizontal ResizeDivider Widget Test', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        themeMode: ThemeMode.dark,
        child: ResizeDivider(
          direction: Axis.vertical,
          onHorizontalDragUpdate: (_) {},
        ),
      ),
    );

    expectCalls(
      direction: Axis.vertical,
      cursor: SystemMouseCursors.resizeColumn,
    );
  });
}
