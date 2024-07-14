import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/shared/controllers/base_form_controller.dart';
import 'package:myoro_player/shared/widgets/forms/base_form.dart';

import '../../../base_test_widget.dart';

void main() {
  void expectCalls() {
    expect(find.byType(BaseForm<String>), findsOneWidget);
    expect(find.byType(Form), findsOneWidget);
    expect(find.byType(SizedBox), findsOneWidget); // [builder]'s [SizedBox]
  }

  testWidgets('BaseForm error case widget test.', (tester) async {
    final controller = BaseFormController<String>();

    await tester.pumpWidget(
      BaseTestWidget(
        child: BaseForm<String>(
          controller: controller,
          validationCallback: () => 'Error',
          requestCallback: () => null,
          onSuccessCallback: (_) {},
          onErrorCallback: (error) => print('[onErrorCallback] triggered: "$error".'),
          builder: (context) => const SizedBox.shrink(),
        ),
      ),
    );

    expectCalls();
    controller.finishForm();
  });

  testWidgets('BaseForm success case widget test.', (tester) async {
    final controller = BaseFormController<String>();

    await tester.pumpWidget(
      BaseTestWidget(
        child: BaseForm<String>(
          controller: controller,
          validationCallback: () => null,
          requestCallback: () async => 'Result',
          onSuccessCallback: (String? result) => print('[onSuccessCallback] triggered: "$result".'),
          onErrorCallback: (_) {},
          builder: (context) => const SizedBox.shrink(),
        ),
      ),
    );

    expectCalls();
    controller.finishForm();
  });
}
