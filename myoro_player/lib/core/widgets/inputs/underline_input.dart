import 'package:flutter/material.dart';
import 'package:myoro_player/core/enums/input_type_enum.dart';
import 'package:myoro_player/core/widgets/inputs/base_input.dart';

final class UnderlineInput extends StatelessWidget {
  /// Placeholder of the [TextFormField]
  final String? placeholder;

  /// Alignment of the [TextFormField]'s text
  final TextAlign? textAlign;

  /// [Form] ([BaseForm]) validation function to trigger events here within the input
  ///
  /// Returns a [String] if there is an error, null if successful
  final InputValidationCallback? validationCallback;

  /// Controller of the [TextFormField]
  final TextEditingController controller;

  /// [FocusNode] of the [TextFormField]
  final FocusNode? focusNode;

  const UnderlineInput({
    super.key,
    this.placeholder,
    this.textAlign,
    this.validationCallback,
    required this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return BaseInput(
      inputType: InputTypeEnum.underline,
      placeholder: placeholder,
      textAlign: textAlign,
      validationCallback: validationCallback,
      controller: controller,
      focusNode: focusNode,
    );
  }
}
