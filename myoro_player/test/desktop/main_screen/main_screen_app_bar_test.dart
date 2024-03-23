import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/desktop/main_screen/main_screen_app_bar.dart';
import 'package:myoro_player/widgets/app_bars/base_app_bar.dart';
import 'package:myoro_player/widgets/buttons/icon_without_feedback_button.dart';
import 'package:myoro_player/widgets/icons/base_svg.dart';

import '../../base_test_widget.dart';

void main() {
  testWidgets('MainScreenAppBar Widget Test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        testType: TestTypeEnum.appBar,
        child: MainScreenAppBar(),
      ),
    );

    expect(find.byType(MainScreenAppBar), findsOneWidget);
    expect(find.byType(BaseAppBar), findsOneWidget);
    expect(find.byType(BaseSvg), findsOneWidget);
    expect(find.byType(Spacer), findsOneWidget);
    expect(find.byType(IconWithoutFeedbackButton), findsOneWidget);
  });
}
