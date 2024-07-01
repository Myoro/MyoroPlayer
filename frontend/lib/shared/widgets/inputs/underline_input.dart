import 'package:flutter/material.dart';
import 'package:frontend/shared/enums/input_type_enum.dart';
import 'package:frontend/shared/widgets/inputs/base_input.dart';

final class UnderlineInput extends StatelessWidget {
  final String? placeholder;
  final TextAlign? textAlign;
  final TextEditingController controller;
  final FocusNode? focusNode;

  const UnderlineInput({
    super.key,
    this.placeholder,
    this.textAlign,
    required this.controller,
    this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return BaseInput(
      inputType: InputTypeEnum.underline,
      placeholder: placeholder,
      textAlign: textAlign,
      controller: controller,
      focusNode: focusNode,
    );
  }
}
