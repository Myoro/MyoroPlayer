import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/widgets/dividers/basic_divider.dart';
import 'package:frontend/shared/widgets/titles/underline_title.dart';

import '../../../base_test_widget.dart';

void main() {
  testWidgets('UnderlineTitle Widget Test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        child: UnderlineTitle(
          text: 'Title',
        ),
      ),
    );

    expect(find.byType(UnderlineTitle), findsOneWidget);
    expect(
      find.byWidgetPredicate((w) => (w is Column &&
          w.children.length == 3 &&
          w.children.first is Text &&
          (w.children.first as Text).data == 'Title' &&
          w.children[1] is SizedBox &&
          (w.children[1] as SizedBox).height == 5 &&
          w.children.last is BasicDivider &&
          (w.children.last as BasicDivider).direction == Axis.horizontal)),
      findsOneWidget,
    );
  });
}
