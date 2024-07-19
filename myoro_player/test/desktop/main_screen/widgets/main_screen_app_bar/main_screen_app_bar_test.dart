import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/desktop/main_screen/widgets/main_screen_app_bar/main_screen_app_bar.dart';
import 'package:myoro_player/shared/widgets/screens/main_screen/main_screen_app_bar_options_drawer.dart';
import 'package:myoro_player/shared/design_system/image_design_system.dart';
import 'package:myoro_player/shared/enums/image_size_enum.dart';
import 'package:myoro_player/shared/widgets/app_bars/base_app_bar.dart';
import 'package:myoro_player/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:myoro_player/shared/widgets/images/base_image.dart';

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
      find.byWidgetPredicate(
        (w) => w is BaseAppBar && w.children.length == 3 && w.children.first is Padding && w.children[1] is Spacer && w.children[2] is IconTextHoverButton,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => (w is Padding &&
          w.padding == const EdgeInsets.only(left: 5) &&
          w.child is BaseImage &&
          (w.child as BaseImage).svgPath == ImageDesignSystem.logo &&
          (w.child as BaseImage).size == ImageSizeEnum.small.size + 10)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => w is IconTextHoverButton && w.icon == Icons.menu && w.iconSize == ImageSizeEnum.small.size),
      findsOneWidget,
    );

    // Testing the drawer menu button
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pump();
    expect(find.byType(MainScreenAppBarOptionsDrawer), findsOneWidget);
  });
}
