import 'package:flutter/material.dart';

/// [Widget] that all [TextField] files (files in this directory) derive from
class BaseTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextStyle? textStyle;
  final double width;
  final bool obscureText;

  const BaseTextField({
    super.key,
    required this.controller,
    required this.width,
    this.textStyle,
    this.obscureText = false,
  });

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final UnderlineInputBorder border = UnderlineInputBorder(
      borderSide: BorderSide(
        width: 2,
        color: theme.colorScheme.onPrimary,
      ),
    );

    return SizedBox(
      width: width,
      height: 45,
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        style: textStyle ?? theme.textTheme.bodyMedium,
        decoration: InputDecoration(
          enabledBorder: border,
          focusedBorder: border,
          contentPadding: EdgeInsets.zero,
        ),
      ),
    );
  }
}
