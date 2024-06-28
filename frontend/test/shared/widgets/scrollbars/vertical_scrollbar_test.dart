import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/widgets/scrollbars/vertical_scrollbar.dart';

import '../../../base_test_widget.dart';

void main() {
  testWidgets('VerticalScrollbar widget test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        child: VerticalScrollbar(),
      ),
    );

    expect(find.byType(VerticalScrollbar), findsOneWidget);

    expect(
      find.byWidgetPredicate((w) => (w is SingleChildScrollView &&
          w.child is Padding &&
          (w.child as Padding).padding == const EdgeInsets.symmetric(horizontal: 13) &&
          (w.child as Padding).child is Column &&
          ((w.child as Padding).child as Column).children.isEmpty)),
      findsOneWidget,
    );
  });
}
