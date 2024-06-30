import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/widgets/dividers/basic_divider.dart';
import 'package:frontend/shared/widgets/headers/underline_header.dart';

import '../../../base_test_widget.dart';

void main() {
  const header = 'Header';

  testWidgets('UnderlineHeader widget test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        child: UnderlineHeader(
          header: header,
        ),
      ),
    );

    expect(find.byType(UnderlineHeader), findsOneWidget);

    expect(
      find.byWidgetPredicate((w) => (w is Column &&
          w.children.length == 3 &&
          w.children.first is Text &&
          w.children[1] is SizedBox &&
          (w.children[1] as SizedBox).height == 3 &&
          w.children.last is BasicDivider)),
      findsOneWidget,
    );

    expect(find.byWidgetPredicate((w) => w is Text && w.data == header), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is BasicDivider && w.direction == Axis.horizontal && w.padding == const EdgeInsets.symmetric(horizontal: 10),
      ),
      findsOneWidget,
    );
  });
}
