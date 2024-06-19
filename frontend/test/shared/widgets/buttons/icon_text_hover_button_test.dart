import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/widgets/buttons/base_hover_button.dart';
import 'package:frontend/shared/widgets/buttons/icon_text_hover_button.dart';

import '../../../base_test_widget.dart';

void main() {
  void expectCalls() {
    expect(find.byType(IconTextHoverButton), findsOneWidget);
    expect(find.byType(BaseHoverButton), findsOneWidget);
  }

  testWidgets('(Icon only) IconTextHoverButton Widget Test', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        child: IconTextHoverButton(
          icon: Icons.abc,
          iconSize: ImageSizeEnum.small.size,
          onTap: () {
            if (kDebugMode) {
              print('IconTextHoverButton #1 onTap working');
            }
          },
        ),
      ),
    );

    expectCalls();

    expect(
      find.byWidgetPredicate((w) => w is Row && w.children.length == 1 && w.children.first is Icon),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => w is Icon && w.icon == Icons.abc && w.size == ImageSizeEnum.small.size),
      findsOneWidget,
    );

    await tester.tap(find.byType(IconTextHoverButton));
  });

  testWidgets('(Text only) IconTextHoverButton Widget Test', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        child: IconTextHoverButton(
          text: 'IconTextHoverButton #2',
          onTap: () {
            if (kDebugMode) {
              print('IconTextHoverButton #2 onTap working');
            }
          },
        ),
      ),
    );

    expectCalls();

    expect(
      find.byWidgetPredicate(
        (w) => w is Row && w.children.length == 1 && w.children.first is Expanded && (w.children.first as Expanded).child is Text,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => w is Text && w.data == 'IconTextHoverButton #2'),
      findsOneWidget,
    );

    await tester.tap(find.byType(IconTextHoverButton));
  });

  testWidgets('(Icon + Text) IconTextHoverButton Widget Test', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        child: IconTextHoverButton(
          icon: Icons.ac_unit,
          iconSize: ImageSizeEnum.medium.size,
          text: 'IconTextHoverButton #3',
          onTap: () {
            if (kDebugMode) {
              print('IconTextHoverButton #3 onTap working');
            }
          },
        ),
      ),
    );

    expectCalls();

    expect(
      find.byWidgetPredicate((w) => (w is Row &&
          w.children.length == 3 &&
          w.children.first is Icon &&
          w.children[1] is SizedBox &&
          (w.children[1] as SizedBox).width == 5 &&
          w.children.last is Expanded &&
          (w.children.last as Expanded).child is Text)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (w) => w is Icon && w.icon == Icons.ac_unit && w.size == ImageSizeEnum.medium.size,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => w is Text && w.data == 'IconTextHoverButton #3'),
      findsOneWidget,
    );

    await tester.tap(find.byType(IconTextHoverButton));
  });
}
