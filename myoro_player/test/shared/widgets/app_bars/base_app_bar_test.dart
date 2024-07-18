import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/shared/widgets/app_bars/base_app_bar.dart';

import '../../../base_test_widget.dart';

void main() {
  testWidgets('BaseAppBar widget test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        testType: TestTypeEnum.appBar,
        child: BaseAppBar(children: []),
      ),
    );

    expect(find.byType(BaseAppBar), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is AppBar && w.actions?.length == 1 && w.actions?.first is Container && w.title is Row && (w.title as Row).children.isEmpty,
      ),
      findsOneWidget,
    );
  });
}
