import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/shared/widgets/scrollbars/vertical_scroll_list.dart';

import '../../../base_test_widget.dart';

void main() {
  testWidgets('VerticallScrollList widget test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        child: VerticalScrollList(),
      ),
    );

    expect(find.byType(VerticalScrollList), findsOneWidget);

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
