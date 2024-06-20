import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/desktop/main_screen/widgets/main_screen_app_bar/main_screen_app_bar.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/widgets/app_bars/base_app_bar.dart';
import 'package:frontend/shared/widgets/buttons/icon_text_hover_button.dart';

import '../../../../base_test_widget.dart';

void main() {
  testWidgets('MainScreenAppBar Widget Test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        child: MainScreenAppBar(),
      ),
    );

    expect(find.byType(MainScreenAppBar), findsOneWidget);

    expect(
      find.byWidgetPredicate((w) => (w is BaseAppBar &&
          w.children.length == 3 &&
          w.children.first is Text &&
          (w.children.first as Text).data == 'MyoroPlayer' &&
          w.children[1] is Spacer &&
          w.children.last is IconTextHoverButton)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (w) => w is IconTextHoverButton && w.padding == const EdgeInsets.all(3) && w.icon == Icons.menu && w.iconSize == ImageSizeEnum.small.size,
      ),
      findsOneWidget,
    );
  });
}
