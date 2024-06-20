import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/widgets/scrollbars/vertical_scrollbar.dart';

import '../../../base_test_widget.dart';

void main() {
  testWidgets('VerticallScrollbar Widget Test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        child: VerticalScrollbar(),
      ),
    );

    expect(find.byType(VerticalScrollbar), findsOneWidget);

    expect(
      find.byWidgetPredicate((w) => (w is Scrollbar &&
          w.thumbVisibility == true &&
          w.child is SingleChildScrollView &&
          (w.child as SingleChildScrollView).child is Padding &&
          ((w.child as SingleChildScrollView).child as Padding).padding == const EdgeInsets.symmetric(horizontal: 12) &&
          ((w.child as SingleChildScrollView).child as Padding).child is Column &&
          (((w.child as SingleChildScrollView).child as Padding).child as Column).children.length == 0)),
      findsOneWidget,
    );
  });
}
