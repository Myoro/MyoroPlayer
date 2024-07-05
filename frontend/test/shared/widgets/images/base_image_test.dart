import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/design_system/decoration_design_system.dart';
import 'package:frontend/shared/design_system/image_design_system.dart';
import 'package:frontend/shared/widgets/images/base_image.dart';

import '../../../base_test_widget.dart';

void main() {
  const double width = 500;

  void expectCalls({required bool isImageWidget}) {
    expect(find.byType(BaseImage), findsOneWidget);
    expect(
      find.byWidgetPredicate((w) => (w is ClipRRect &&
          w.borderRadius == DecorationDesignSystem.borderRadius &&
          w.child is Padding &&
          (w.child as Padding).padding == const EdgeInsets.all(3) &&
          (w.child as Padding).child.runtimeType == (isImageWidget ? Image : SvgPicture))),
      findsOneWidget,
    );

    if (isImageWidget) {
      expect(
        find.byWidgetPredicate((w) => w is Image && w.width == width && w.fit == BoxFit.fitWidth),
        findsOneWidget,
      );
    } else {
      expect(
        find.byWidgetPredicate((w) => w is SvgPicture && w.width == width && w.fit == BoxFit.fitWidth),
        findsOneWidget,
      );
    }
  }

  testWidgets('BaseImage [Image] widget test.', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        child: BaseImage(
          localImagePath: 'assets/cat.jpg',
          width: width,
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
          width: width,
        ),
      ),
    );

    expectCalls(isImageWidget: false);
  });
}
