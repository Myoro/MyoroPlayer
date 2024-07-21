import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/core/design_system/color_design_system.dart';
import 'package:myoro_player/core/design_system/decoration_design_system.dart';
import 'package:myoro_player/core/enums/image_size_enum.dart';
import 'package:myoro_player/core/widgets/buttons/icon_text_hover_button.dart';
import 'package:myoro_player/core/widgets/forms/base_form.dart';
import 'package:myoro_player/core/widgets/modals/base_modal.dart';

import '../../../base_test_widget.dart';

void main() {
  const key = Key('');
  const title = 'BaseModal Title';
  const childText = 'BaseModal child';

  void show(BuildContext context, [bool returnValidationError = false]) {
    BaseModal.show<String>(
      context,
      validationCallback: () => returnValidationError ? '' : null,
      requestCallback: () async => 'Response',
      onSuccessCallback: (String? result) {
        if (kDebugMode) {
          print('[onSuccessCallback]: result: "$result"');
        }
      },
      onErrorCallback: (String error) {
        if (kDebugMode) {
          print('[onErrorCallback]: error: "$error"');
        }
      },
      title: title,
      child: const Text(
        childText,
      ),
    );
  }

  Widget widget({bool returnValidationError = false}) {
    return BaseTestWidget(
      themeMode: ThemeMode.dark,
      child: Builder(
        builder: (context) {
          return GestureDetector(
            key: key,
            onTap: () => show(
              context,
              returnValidationError,
            ),
          );
        },
      ),
    );
  }

  Future<void> expectCalls(WidgetTester tester) async {
    await tester.tap(find.byKey(key));
    await tester.pump();

    expect(find.byType(BaseModal<String>), findsOneWidget);

    // Wrapper
    expect(find.byType(LayoutBuilder), findsOneWidget);
    expect(find.byWidgetPredicate((w) => w is Center && w.child is Material), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is Material && w.type == MaterialType.transparency && w.child is Container,
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate((w) => (w is Container &&
          w.padding == const EdgeInsets.all(10) &&
          w.decoration ==
              BoxDecoration(
                color: DarkModeColorDesignSystem.background,
                borderRadius: DecorationDesignSystem.borderRadius,
                border: Border.all(
                  width: 2,
                  color: DarkModeColorDesignSystem.onBackground,
                ),
              ) &&
          w.constraints?.maxWidth == 350 &&
          w.child is BaseForm<dynamic>)),
      findsOneWidget,
    );

    // Base contents
    expect(
      find.byWidgetPredicate((w) => (w is Column &&
          w.mainAxisSize == MainAxisSize.min &&
          w.children.length == 5 &&
          w.children.first is Row &&
          w.children[1] is SizedBox &&
          (w.children[1] as SizedBox).height == 10 &&
          w.children[2] is Text && // Text inserted in [child]
          w.children[3] is SizedBox &&
          (w.children[3] as SizedBox).height == 15 &&
          w.children.last is Row)),
      findsOneWidget,
    );

    // Title + close button
    expect(
      find.byWidgetPredicate((w) => (w is Row &&
          w.children.length == 3 &&
          w.children.first is Expanded &&
          (w.children.first as Expanded).child is Text &&
          w.children[1] is SizedBox &&
          (w.children[1] as SizedBox).width == 20 &&
          w.children.last is IconTextHoverButton)),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate((w) => w is Text && w.data == title),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (w) => w is IconTextHoverButton && w.icon == Icons.close && w.iconSize == ImageSizeEnum.small.size - 10,
      ),
      findsOneWidget,
    );

    // Widget inserted in [child]
    expect(find.byWidgetPredicate((w) => w is Text && w.data == childText), findsOneWidget);

    // Confirm/cancel buttons
    expect(
      find.byWidgetPredicate((w) => (w is Row &&
          w.children.length == 3 &&
          w.children.first is Expanded &&
          (w.children.first as Expanded).child is IconTextHoverButton &&
          w.children[1] is SizedBox &&
          (w.children[1] as SizedBox).width == 10 &&
          w.children.last is Expanded &&
          (w.children.last as Expanded).child is IconTextHoverButton)),
      findsOneWidget,
    );
    for (final text in ['Confirm', 'Cancel']) {
      expect(
        find.byWidgetPredicate(
          (w) => w is IconTextHoverButton && w.text == text && w.textAlign == TextAlign.center && w.bordered,
        ),
        findsOneWidget,
      );
    }
  }

  testWidgets('BaseModal close text button case widget test.', (tester) async {
    await tester.pumpWidget(widget());
    await expectCalls(tester);
    await tester.tap(find.text('Cancel'));
  });

  testWidgets('BaseModal close icon button case widget test.', (tester) async {
    await tester.pumpWidget(widget());
    await expectCalls(tester);
    await tester.tap(find.byIcon(Icons.close));
  });

  testWidgets('BaseModal confirm text button error case widget test.', (tester) async {
    await tester.pumpWidget(widget(returnValidationError: true));
    await expectCalls(tester);
    await tester.tap(find.text('Confirm'));
  });

  testWidgets('BaseModal confirm text button success case widget test.', (tester) async {
    await tester.pumpWidget(widget());
    await expectCalls(tester);
    await tester.tap(find.text('Confirm'));
  });
}
