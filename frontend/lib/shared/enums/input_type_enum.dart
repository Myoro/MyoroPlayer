import 'package:flutter/material.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/design_system/decoration_design_system.dart';

enum InputTypeEnum {
  outline,
  underline;

  InputBorder border(BuildContext context) {
    final onBackground = ColorDesignSystem.onBackground(context);
    final borderSide = BorderSide(
      width: 2,
      color: onBackground,
    );

    switch (this) {
      case InputTypeEnum.outline:
        return OutlineInputBorder(
          borderRadius: DecorationDesignSystem.borderRadius,
          borderSide: borderSide,
        );
      case InputTypeEnum.underline:
        return UnderlineInputBorder(
          borderSide: borderSide,
        );
    }
  }
}
