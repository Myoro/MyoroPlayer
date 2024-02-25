import 'package:flutter/material.dart';
import 'package:myoro_player/widgets/shared/inputs/base_text_field.dart';

class BaseTextFieldForm extends StatelessWidget {
  final String title;
  final TextStyle? textStyle;
  final double textFieldWidth;
  final bool obscureText;
  final TextEditingController controller;

  /// Will place an * before title
  final bool obligatory;

  const BaseTextFieldForm({
    super.key,
    required this.title,
    required this.textFieldWidth,
    required this.controller,
    this.textStyle,
    this.obligatory = false,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Expanded(
            child: Text(
              '${obligatory ? '*' : ''}$title:',
              textAlign: TextAlign.center,
              style: textStyle ?? Theme.of(context).textTheme.bodyMedium,
            ),
          ),
          const SizedBox(width: 10),
          BaseTextField(
            controller: controller,
            textStyle: textStyle,
            width: textFieldWidth,
            obscureText: obscureText,
          ),
        ],
      );
}
