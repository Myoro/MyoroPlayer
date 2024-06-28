import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/screens/main_screen/widgets/main_screen_app_bar/main_screen_app_bar.dart';
import 'package:myoro_player/shared/enums/image_size_enum.dart';
import 'package:myoro_player/shared/widgets/app_bars/base_app_bar.dart';
import 'package:myoro_player/shared/widgets/buttons/icon_text_hover_button.dart';

import '../../../../base_test_widget.dart';

void main() {
  testWidgets('MainScreenAppBar widget test.', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        testType: TestTypeEnum.appBar,
        child: MainScreenAppBar(),
      ),
    );

    expect(find.byType(MainScreenAppBar), findsOneWidget);

    expect(
      find.byWidgetPredicate((w) => (w is BaseAppBar &&
          w.children.length == 5 &&
          w.children.first is SizedBox &&
          (w.children.first as SizedBox).width == 10 &&
          w.children[1] is Text &&
          (w.children[1] as Text).data == 'MyoroPlayer' &&
          w.children[2] is Spacer &&
          w.children[3] is IconTextHoverButton &&
          w.children.last is SizedBox &&
          (w.children.last as SizedBox).width == 3)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => (w is IconTextHoverButton &&
          w.icon == Icons.menu &&
          w.iconSize == ImageSizeEnum.small.size)),
      findsOneWidget,
    );
  });
}
