import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/desktop/main_screen/widgets/main_screen_body/main_screen_body_footer.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:frontend/shared/widgets/sliders/base_slider.dart';

import '../../../../base_test_widget.dart';

void main() {
  testWidgets('MainScreenBodyFooter Widget Test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        themeMode: ThemeMode.dark,
        child: MainScreenBodyFooter(),
      ),
    );

    expect(find.byType(MainScreenBodyFooter), findsOneWidget);

    expect(
      find.byWidgetPredicate((w) => (w is Padding &&
          w.padding == const EdgeInsets.symmetric(horizontal: 20) &&
          w.child is SizedBox &&
          (w.child as SizedBox).height == 65 &&
          (w.child as SizedBox).child is LayoutBuilder)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => (w is Row &&
          w.mainAxisAlignment == MainAxisAlignment.center &&
          w.children.length == 5 &&
          w.children[1] is SizedBox &&
          (w.children[1] as SizedBox).width == 10 &&
          w.children[3] is SizedBox &&
          (w.children[3] as SizedBox).width == 10)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => w is Expanded && w.child is Row),
      findsAtLeastNWidgets(1),
    );

    expect(
      find.byWidgetPredicate((w) => (w is Row &&
          w.children.length == 3 &&
          w.children.first is Icon &&
          w.children[1] is SizedBox &&
          (w.children[1] as SizedBox).width == 5 &&
          w.children.last is Expanded)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (w) => w is Icon && w.icon == Icons.music_note && w.size == ImageSizeEnum.small.size && w.color == DarkModeColorDesignSystem.onBackground,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => w is Expanded && w.child is Column),
      findsAtLeastNWidgets(1),
    );

    expect(
      find.byWidgetPredicate((w) => (w is Column &&
          w.mainAxisAlignment == MainAxisAlignment.center &&
          w.crossAxisAlignment == CrossAxisAlignment.start &&
          w.children.length == 2 &&
          w.children.first is Text &&
          (w.children.first as Text).data == '<Song name here>qwiejqwoiejqwoiej' &&
          (w.children.first as Text).maxLines == 1 &&
          (w.children.first as Text).overflow == TextOverflow.ellipsis &&
          (w.children.last as Text).data == '<Song artist her> iqwjeqoijeqoiej' &&
          (w.children.last as Text).maxLines == 1 &&
          (w.children.last as Text).overflow == TextOverflow.ellipsis)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => (w is Column &&
          w.mainAxisAlignment == MainAxisAlignment.center &&
          w.children.length == 2 &&
          w.children.first is BaseSlider &&
          w.children.last is Row &&
          (w.children.last as Row).children.length == 9)),
      findsOneWidget,
    );

    final icons = [
      Icons.shuffle,
      Icons.skip_previous,
      Icons.pause,
      Icons.skip_next,
      Icons.repeat,
      Icons.queue_music,
    ];

    for (final icon in icons) {
      expect(
        find.byWidgetPredicate(
          (w) => w is IconTextHoverButton && w.icon == icon && w.iconSize == ImageSizeEnum.small.size,
        ),
        findsOneWidget,
      );
    }

    expect(
      find.byWidgetPredicate((w) => w is Expanded && w.child is Row),
      findsAtLeastNWidgets(1),
    );

    expect(
      find.byWidgetPredicate((w) => (w is Row &&
          w.mainAxisAlignment == MainAxisAlignment.end &&
          w.children.length == 2 &&
          w.children.first is IconTextHoverButton &&
          w.children.last is BaseSlider &&
          (w.children.last as BaseSlider).width == 150)),
      findsOneWidget,
    );
  });
}
