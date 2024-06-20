import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/desktop/main_screen/widgets/main_screen.dart';
import 'package:frontend/desktop/main_screen/widgets/main_screen_app_bar/main_screen_app_bar.dart';
import 'package:frontend/desktop/main_screen/widgets/main_screen_body/main_screen_body.dart';
import 'package:frontend/shared/widgets/scaffolds/base_scaffold.dart';

import '../../../base_test_widget.dart';

void main() {
  testWidgets('MainScreen Widget Test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        testType: TestTypeEnum.screen,
        child: MainScreen(),
      ),
    );

    expect(find.byType(MainScreen), findsOneWidget);

    expect(
      find.byWidgetPredicate(
        (w) => w is BaseScaffold && w.appBar is MainScreenAppBar && w.body is MainScreenBody,
      ),
      findsOneWidget,
    );
  });
}
