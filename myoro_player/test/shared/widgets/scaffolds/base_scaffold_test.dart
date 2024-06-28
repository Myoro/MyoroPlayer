import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/shared/widgets/scaffolds/base_scaffold.dart';

import '../../../base_test_widget.dart';

void main() {
  testWidgets('BaseScaffold widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        testType: TestTypeEnum.screen,
        child: BaseScaffold(
          appBar: AppBar(),
          body: const SizedBox.shrink(),
        ),
      ),
    );

    expect(find.byType(BaseScaffold), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is Scaffold && w.appBar is AppBar && w.body is SizedBox && w.endDrawer != null,
      ),
      findsOneWidget,
    );
  });
}
