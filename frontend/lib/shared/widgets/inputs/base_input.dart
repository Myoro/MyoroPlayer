import 'package:flutter/material.dart';
import 'package:frontend/shared/enums/input_type_enum.dart';

/// Widget strictly used to create other inputs, do not
/// use this to build inputs casually within other widgets
final class BaseInput extends StatelessWidget {
  final InputTypeEnum inputType;
  final String? placeholder;
  final TextAlign? textAlign;
  final TextEditingController controller;
  final FocusNode? focusNode;

  const BaseInput({
    super.key,
    required this.inputType,
    required this.placeholder,
    required this.textAlign,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final border = inputType.border(context);

    return TextField(
      controller: controller,
      focusNode: focusNode,
      style: Theme.of(context).textTheme.bodyMedium,
      textAlign: textAlign ?? TextAlign.center,
      decoration: InputDecoration(
        hintText: placeholder,
        focusedBorder: border,
        enabledBorder: border,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
      ),
    );
  }
}
