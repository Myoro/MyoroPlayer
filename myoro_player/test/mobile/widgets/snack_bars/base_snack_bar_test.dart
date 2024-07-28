import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/core/design_system/color_design_system.dart';
import 'package:myoro_player/core/enums/image_size_enum.dart';
import 'package:myoro_player/core/enums/platform_enum.dart';
import 'package:myoro_player/core/enums/snack_bar_type_enum.dart';
import 'package:myoro_player/core/extensions/build_context_extension.dart';
import 'package:myoro_player/core/helpers/platform_helper.dart';
import 'package:myoro_player/core/widgets/buttons/no_feedback_button.dart';
import 'package:myoro_player/core/widgets/dividers/basic_divider.dart';

import '../../../base_test_widget.dart';
import '../../../mocks/platform_helper_mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();
  const message = 'Message';

  setUpAll(() {
    kiwiContainer.registerFactory<PlatformHelper>(
      (_) => PlatformHelperMock.preConfigured(
        platform: faker.randomGenerator.boolean() ? PlatformEnum.android : PlatformEnum.ios,
      ),
    );
  });

  tearDownAll(() => kiwiContainer.clear());

  Future<void> setup(WidgetTester tester, SnackBarTypeEnum snackBarType) async {
    await tester.pumpWidget(
      BaseTestWidget(
        themeMode: ThemeMode.dark,
        child: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () {
                if (snackBarType.isDialog) {
                  context.showDialogSnackBar(message);
                }

                if (snackBarType.isError) {
                  context.showErrorSnackBar(message);
                }
              },
            );
          },
        ),
      ),
    );

    await tester.tap(find.byType(GestureDetector));
    await tester.pumpAndSettle();
  }

  void expectCalls(SnackBarTypeEnum snackBarType) {
    expect(
      find.byWidgetPredicate(
        (w) => w is SnackBar && w.backgroundColor == DarkModeColorDesignSystem.background && w.padding == EdgeInsets.zero,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => (w is Column &&
          w.children.length == 2 &&
          w.children.first is BasicDivider &&
          (w.children.first as BasicDivider).direction == Axis.horizontal &&
          w.children.last is Padding &&
          (w.children.last as Padding).padding == const EdgeInsets.all(10) &&
          (w.children.last as Padding).child is Row)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => (w is Row &&
          w.children.length == 3 &&
          w.children.first is Expanded &&
          (w.children.first as Expanded).child is Text &&
          ((w.children.first as Expanded).child as Text).data == message &&
          ((w.children.first as Expanded).child as Text).maxLines == 2 &&
          ((w.children.first as Expanded).child as Text).overflow == TextOverflow.ellipsis &&
          w.children[1] is SizedBox &&
          (w.children[1] as SizedBox).width == 5 &&
          w.children.last is NoFeedbackButton &&
          (w.children.last as NoFeedbackButton).child is Icon &&
          ((w.children.last as NoFeedbackButton).child as Icon).icon == Icons.close &&
          ((w.children.last as NoFeedbackButton).child as Icon).size == ImageSizeEnum.small.size - 10 &&
          ((w.children.last as NoFeedbackButton).child as Icon).color ==
              (snackBarType.isDialog ? DarkModeColorDesignSystem.onBackground : ColorDesignSystem.onError))),
      findsOneWidget,
    );
  }

  testWidgets('Dialog BaseSnackBar widget test.', (tester) async {
    await setup(tester, SnackBarTypeEnum.dialog);
    expectCalls(SnackBarTypeEnum.dialog);
    await tester.tap(find.byType(NoFeedbackButton));
  });

  testWidgets('Error BaseSnackBar widget test.', (tester) async {
    await setup(tester, SnackBarTypeEnum.error);
    expectCalls(SnackBarTypeEnum.error);
    await tester.tap(find.byType(NoFeedbackButton));
  });
}
