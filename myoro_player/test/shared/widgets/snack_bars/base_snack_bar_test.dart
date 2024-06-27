import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/design_system/decoration_design_system.dart';
import 'package:myoro_player/shared/enums/image_size_enum.dart';
import 'package:myoro_player/shared/enums/snack_bar_type_enum.dart';
import 'package:myoro_player/shared/helpers/snack_bar_helper.dart';
import 'package:myoro_player/shared/widgets/buttons/no_feedback_button.dart';

import '../../../base_test_widget.dart';

void main() {
  final kiwiContainer = KiwiContainer();

  setUp(() => kiwiContainer.registerFactory<SnackBarHelper>((_) => SnackBarHelper()));
  tearDown(() => kiwiContainer.clear());

  void expectCalls(SnackBarTypeEnum snackBarType) {
    expect(
      find.byWidgetPredicate((w) => (w is Container &&
          w.decoration ==
              BoxDecoration(
                color: snackBarType.isTypeError ? ColorDesignSystem.error : DarkModeColorDesignSystem.background,
                borderRadius: DecorationDesignSystem.borderRadius,
                border: Border.all(
                  width: 2,
                  color: snackBarType.isTypeError ? ColorDesignSystem.error : DarkModeColorDesignSystem.onBackground,
                ),
              ) &&
          w.child is Padding)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (w) => w is Padding && w.padding == const EdgeInsets.all(10) && w.child is Row,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => (w is Row &&
          w.children.length == 3 &&
          w.children.first is Expanded &&
          w.children[1] is SizedBox &&
          (w.children[1] as SizedBox).width == 5 &&
          w.children.last is NoFeedbackButton)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => (w is Expanded &&
          w.child is Text &&
          (w.child as Text).maxLines == 2 &&
          (w.child as Text).overflow == TextOverflow.ellipsis &&
          (w.child as Text).data == '${snackBarType.isTypeError ? 'Error' : 'Dialog'} snackbar')),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => (w is NoFeedbackButton &&
          w.child is Icon &&
          (w.child as Icon).icon == Icons.close &&
          (w.child as Icon).size == ImageSizeEnum.small.size - 10 &&
          (w.child as Icon).color == (snackBarType.isTypeError ? ColorDesignSystem.onError : DarkModeColorDesignSystem.onBackground))),
      findsOneWidget,
    );
  }

  testWidgets('Dialog BaseSnackBar widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        themeMode: ThemeMode.dark,
        child: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () => kiwiContainer.resolve<SnackBarHelper>().showDialogSnackBar(
                    context,
                    'Dialog snackbar',
                  ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    expectCalls(SnackBarTypeEnum.dialog);
  });

  testWidgets('Error BaseSnackBar widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        themeMode: ThemeMode.dark,
        child: Builder(
          builder: (context) {
            return GestureDetector(
              onTap: () => kiwiContainer.resolve<SnackBarHelper>().showErrorSnackBar(
                    context,
                    'Error snackbar',
                  ),
            );
          },
        ),
      ),
    );

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    expectCalls(SnackBarTypeEnum.error);
  });
}
