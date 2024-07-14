import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/shared/enums/input_type_enum.dart';
import 'package:myoro_player/shared/widgets/inputs/base_input.dart';
import 'package:myoro_player/shared/widgets/inputs/outline_input.dart';

import '../../../base_test_widget.dart';

void main() {
  const placeholder = 'OutlineInput Placeholder';
  const textAlign = TextAlign.end;

  testWidgets('OutlineInput widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        child: OutlineInput(
          placeholder: placeholder,
          textAlign: textAlign,
          controller: TextEditingController(),
        ),
      ),
    );

    expect(find.byType(OutlineInput), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is BaseInput && w.inputType == InputTypeEnum.outline && w.placeholder == placeholder && w.textAlign == textAlign,
      ),
      findsOneWidget,
    );
    expect(find.byType(TextFormField), findsOneWidget);
  });
}
