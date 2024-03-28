import 'package:flutter/material.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/design_system/theme_data.dart';
import 'package:myoro_player/shared/enums/font_size_enum.dart';

TextStyle _textStyle(
  bool isDarkMode, {
  required double fontSize,
  FontStyle fontStyle = FontStyle.normal,
  FontWeight fontWeight = FontWeight.normal,
}) =>
    TextStyle(
      fontFamily: 'Ubuntu',
      fontSize: fontSize,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
      color: isDarkMode ? DarkModeColorDesignSystem.onBackground : LightModeColorDesignSystem.onBackground,
    );

/// *** DO NOT USE THIS WITHIN THE APPLICATION, only supposed to be called in [createTheme] ***
/// 3 font types (regular, italicized, bolded)
/// 3 sizes for each font type (small, medium, large)
class TypographyDesignSystem {
  static TextStyle regularSmall(bool isDarkMode) => _textStyle(
        isDarkMode,
        fontSize: FontSizeEnum.small.size,
      );

  static TextStyle regularMedium(bool isDarkMode) => _textStyle(
        isDarkMode,
        fontSize: FontSizeEnum.medium.size,
      );

  static TextStyle regularLarge(bool isDarkMode) => _textStyle(
        isDarkMode,
        fontSize: FontSizeEnum.large.size,
      );

  static TextStyle italicSmall(bool isDarkMode) => _textStyle(
        isDarkMode,
        fontSize: FontSizeEnum.small.size,
        fontStyle: FontStyle.italic,
      );

  static TextStyle italicMedium(bool isDarkMode) => _textStyle(
        isDarkMode,
        fontSize: FontSizeEnum.medium.size,
        fontStyle: FontStyle.italic,
      );

  static TextStyle italicLarge(bool isDarkMode) => _textStyle(
        isDarkMode,
        fontSize: FontSizeEnum.large.size,
        fontStyle: FontStyle.italic,
      );

  static TextStyle boldSmall(bool isDarkMode) => _textStyle(
        isDarkMode,
        fontSize: FontSizeEnum.small.size,
        fontWeight: FontWeight.bold,
      );

  static TextStyle boldMedium(bool isDarkMode) => _textStyle(
        isDarkMode,
        fontSize: FontSizeEnum.medium.size,
        fontWeight: FontWeight.bold,
      );

  static TextStyle boldLarge(bool isDarkMode) => _textStyle(
        isDarkMode,
        fontSize: FontSizeEnum.large.size,
        fontWeight: FontWeight.bold,
      );
}
