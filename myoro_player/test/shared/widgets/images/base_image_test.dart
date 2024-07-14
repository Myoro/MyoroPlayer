import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/shared/design_system/decoration_design_system.dart';
import 'package:myoro_player/shared/design_system/image_design_system.dart';
import 'package:myoro_player/shared/widgets/images/base_image.dart';

import '../../../base_test_widget.dart';

void main() {
  const double size = 500;
  const Color svgColor = Colors.pink;

  void expectCalls({required bool isImageWidget}) {
    expect(find.byType(BaseImage), findsOneWidget);

    expect(
      find.byWidgetPredicate((w) => (w is ClipRRect &&
          w.borderRadius == (isImageWidget ? DecorationDesignSystem.borderRadius : BorderRadius.zero) &&
          w.child.runtimeType == (isImageWidget ? Image : SizedBox))),
      findsOneWidget,
    );

    if (isImageWidget) {
      expect(
        find.byWidgetPredicate((w) => w is Image && w.width == size && w.fit == BoxFit.fitWidth),
        findsOneWidget,
      );
    } else {
      expect(find.byWidgetPredicate((w) => w is SizedBox && w.child is SvgPicture), findsOneWidget);
      expect(
        find.byWidgetPredicate((w) => (w is SvgPicture &&
            w.height == size &&
            w.fit == BoxFit.fitHeight &&
            w.colorFilter ==
                const ColorFilter.mode(
                  svgColor,
                  BlendMode.srcIn,
                ))),
        findsOneWidget,
      );
    }
  }

  testWidgets('BaseImage [Image] widget test.', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        child: BaseImage(
          localImagePath: 'assets/cat.jpg',
          size: size,
        ),
      ),
    );

    expectCalls(isImageWidget: true);
  });

  testWidgets('BaseImage [SvgPicture] widget test.', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        child: BaseImage(
          svgPath: ImageDesignSystem.logo,
          svgColor: svgColor,
          size: size,
        ),
      ),
    );

    expectCalls(isImageWidget: false);
  });
}
