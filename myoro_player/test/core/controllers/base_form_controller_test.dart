import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/core/blocs/base_form_bloc/base_form_bloc.dart';
import 'package:myoro_player/core/controllers/base_form_controller.dart';
import 'package:myoro_player/core/widgets/inputs/outline_input.dart';

import '../../base_test_widget.dart';

void main() {
  final controller = BaseFormController<String>();
  final bloc = BaseFormBloc<String>(
    validationCallback: () => null,
    requestCallback: () async => 'Response',
  );

  tearDown(() => bloc.close());

  testWidgets('BaseFormController.finishForm test.', (tester) async {
    controller.bloc = bloc;

    // BaseFormController.finishForm should trigger the [OutlineInput]'s [TextFormField]'s [validator] function
    await tester.pumpWidget(
      BaseTestWidget(
        child: Form(
          key: controller.formKey,
          child: OutlineInput(
            controller: TextEditingController(),
            validationCallback: (_) {
              if (kDebugMode) {
                print('[validator] executed.');
              }

              return '';
            },
          ),
        ),
      ),
    );

    controller.finishForm();
  });
}
