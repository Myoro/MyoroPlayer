import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/mobile/screens/main_screen/widgets/main_screen_app_bar/main_screen_app_bar.dart';
import 'package:myoro_player/core/design_system/color_design_system.dart';
import 'package:myoro_player/core/design_system/image_design_system.dart';
import 'package:myoro_player/core/enums/image_size_enum.dart';
import 'package:myoro_player/core/widgets/app_bars/base_app_bar.dart';
import 'package:myoro_player/core/widgets/buttons/icon_text_hover_button.dart';
import 'package:myoro_player/core/widgets/drawers/base_drawer.dart';
import 'package:myoro_player/core/widgets/images/base_image.dart';
import 'package:myoro_player/shared/screens/main_screen/main_screen_app_bar_options_drawer.dart';
import 'package:myoro_player/shared/screens/main_screen/playlist_listing.dart';

import '../../../../../base_test_widget.dart';

void main() {
  testWidgets('MainScreenAppBar widget test.', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        themeMode: ThemeMode.dark,
        child: MainScreenAppBar(),
      ),
    );

    expect(find.byType(MainScreenAppBar), findsOneWidget);
    expect(
      find.byWidgetPredicate((w) => (w is BaseAppBar &&
          w.children.length == 5 &&
          w.children.first is IconTextHoverButton &&
          w.children[1] is Spacer &&
          w.children[2] is BaseImage &&
          w.children[3] is Spacer &&
          w.children.last is IconTextHoverButton)),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (w) => w is IconTextHoverButton && w.icon == Icons.playlist_play && w.iconSize == ImageSizeEnum.small.size + 5,
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate((w) => (w is BaseImage &&
          w.svgPath == ImageDesignSystem.logo &&
          w.svgColor == DarkModeColorDesignSystem.onBackground &&
          w.size == ImageSizeEnum.small.size)),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (w) => w is IconTextHoverButton && w.icon == Icons.menu && w.iconSize == ImageSizeEnum.small.size + 5,
      ),
      findsOneWidget,
    );

    await tester.tap(find.byIcon(Icons.playlist_play));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(BaseDrawer), findsOneWidget);
    expect(find.byType(PlaylistListing), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_left), warnIfMissed: false);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(BaseDrawer), findsNothing);

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(BaseDrawer), findsOneWidget);
    expect(find.byType(MainScreenAppBarOptionsDrawer), findsOneWidget);
    await tester.tap(find.byIcon(Icons.arrow_right), warnIfMissed: false);
    await tester.pump(const Duration(seconds: 1));
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(BaseDrawer), findsNothing);
  });
}
