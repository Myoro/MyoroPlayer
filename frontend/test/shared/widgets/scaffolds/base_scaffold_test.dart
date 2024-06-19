import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/widgets/scaffolds/base_scaffold.dart';

import '../../../base_test_widget.dart';

void main() {
  testWidgets('BaseScaffold Widget Test', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        testType: TestTypeEnum.screen,
        child: BaseScaffold(
          appBar: AppBar(),
          body: const Text('Body'),
        ),
      ),
    );

    expect(find.byType(BaseScaffold), findsOneWidget);
    expect(
      find.byWidgetPredicate((w) => w is Scaffold && w.endDrawer != null),
      findsOneWidget,
    );
    expect(find.byType(AppBar), findsOneWidget);
    expect(find.text('Body'), findsOneWidget);
  });
}
