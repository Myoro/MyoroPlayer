import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/core/design_system/color_design_system.dart';
import 'package:myoro_player/core/design_system/image_design_system.dart';
import 'package:myoro_player/core/enums/image_size_enum.dart';
import 'package:myoro_player/core/widgets/buttons/icon_text_hover_button.dart';
import 'package:myoro_player/core/widgets/images/base_image.dart';
import 'package:myoro_player/core/widgets/scaffolds/base_scaffold.dart';
import 'package:myoro_player/mobile/blocs/permission_cubit.dart';
import 'package:myoro_player/mobile/screens/permission_screen/widgets/permission_screen.dart';

import '../../../../base_test_widget.dart';

void main() {
  testWidgets('PermissionScreen widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        testType: TestTypeEnum.screen,
        themeMode: ThemeMode.dark,
        child: PermissionScreen(
          PermissionCubit(),
        ),
      ),
    );

    expect(find.byType(PermissionScreen), findsOneWidget);

    expect(
      find.byWidgetPredicate((w) => (w is BaseScaffold &&
          w.body is SafeArea &&
          (w.body as SafeArea).child is Padding &&
          ((w.body as SafeArea).child as Padding).padding == const EdgeInsets.symmetric(horizontal: 20) &&
          ((w.body as SafeArea).child as Padding).child is Column &&
          (((w.body as SafeArea).child as Padding).child as Column).mainAxisAlignment == MainAxisAlignment.center &&
          (((w.body as SafeArea).child as Padding).child as Column).children.length == 7 &&
          (((w.body as SafeArea).child as Padding).child as Column).children.first is BaseImage &&
          ((((w.body as SafeArea).child as Padding).child as Column).children.first as BaseImage).svgPath == ImageDesignSystem.logo &&
          ((((w.body as SafeArea).child as Padding).child as Column).children.first as BaseImage).svgColor == DarkModeColorDesignSystem.onBackground &&
          ((((w.body as SafeArea).child as Padding).child as Column).children.first as BaseImage).size == ImageSizeEnum.large.size + 50 &&
          (((w.body as SafeArea).child as Padding).child as Column).children[1] is SizedBox &&
          ((((w.body as SafeArea).child as Padding).child as Column).children[1] as SizedBox).height == 30 &&
          (((w.body as SafeArea).child as Padding).child as Column).children[2] is Text &&
          ((((w.body as SafeArea).child as Padding).child as Column).children[2] as Text).data == 'Welcome to MyoroPlayer!' &&
          (((w.body as SafeArea).child as Padding).child as Column).children[3] is SizedBox &&
          ((((w.body as SafeArea).child as Padding).child as Column).children[3] as SizedBox).height == 30 &&
          (((w.body as SafeArea).child as Padding).child as Column).children[4] is Text &&
          ((((w.body as SafeArea).child as Padding).child as Column).children[4] as Text).data ==
              'In order to use MyoroPlayer, you must allow storage & audio permissions.' &&
          (((w.body as SafeArea).child as Padding).child as Column).children[5] is SizedBox &&
          ((((w.body as SafeArea).child as Padding).child as Column).children[5] as SizedBox).height == 30 &&
          (((w.body as SafeArea).child as Padding).child as Column).children.last is Row)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => w is Row && w.children.length == 3 && w.children[1] is SizedBox && (w.children[1] as SizedBox).width == 10),
      findsOneWidget,
    );

    for (final text in ['App settings', 'Use MyoroPlayer!']) {
      expect(
        find.byWidgetPredicate((w) => (w is Expanded &&
            w.child is IconTextHoverButton &&
            (w.child as IconTextHoverButton).text == text &&
            (w.child as IconTextHoverButton).textAlign == TextAlign.center &&
            (w.child as IconTextHoverButton).bordered &&
            (w.child as IconTextHoverButton).padding == const EdgeInsets.all(5))),
        findsOneWidget,
      );
    }
  });
}
