import 'package:flutter/material.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/enums/input_type_enum.dart';
import 'package:frontend/shared/widgets/inputs/outline_input.dart';
import 'package:frontend/shared/widgets/inputs/underline_input.dart';
import 'package:frontend/shared/widgets/forms/base_form.dart';

typedef InputValidationCallback = String? Function(String? text);

/// Widget strictly used to create other inputs, do not
/// use this to build inputs casually within other widgets
final class BaseInput extends StatelessWidget {
  /// Type of input (i.e. [OutlineInput], [UnderlineInput], etc)
  final InputTypeEnum inputType;

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

  const BaseInput({
    super.key,
    required this.inputType,
    required this.placeholder,
    required this.textAlign,
    required this.validationCallback,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    final bodyMedium = Theme.of(context).textTheme.bodyMedium!;
    final border = inputType.border(context);
    final errorBorder = border.copyWith(
      borderSide: border.borderSide.copyWith(
        color: ColorDesignSystem.error,
      ),
    );

    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      style: bodyMedium,
      textAlign: textAlign ?? TextAlign.center,
      decoration: InputDecoration(
        hintText: placeholder,
        focusedBorder: border,
        enabledBorder: border,
        errorBorder: errorBorder,
        focusedErrorBorder: errorBorder,
        errorStyle: bodyMedium.copyWith(
          color: ColorDesignSystem.error,
        ),
        contentPadding: const EdgeInsets.symmetric(
          horizontal: 10,
        ),
      ),
      validator: (text) => validationCallback?.call(text),
    );
  }
}
