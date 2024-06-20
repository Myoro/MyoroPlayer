import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/widgets/app_bars/base_app_bar.dart';

import '../../../base_test_widget.dart';

void main() {
  testWidgets('BaseAppBar Widget Test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        child: BaseAppBar(
          children: [
            Text('Item'),
          ],
        ),
      ),
    );

    expect(find.byType(BaseAppBar), findsOneWidget);

    expect(
      find.byWidgetPredicate(
        (w) => w is AppBar && !w.automaticallyImplyLeading && w.actions?.length == 1 && w.actions?.first is Container && w.title is Row,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => w is Row && w.children.length == 1 && w.children.first is Text),
      findsOneWidget,
    );

    expect(find.text('Item'), findsOneWidget);
  });
}
