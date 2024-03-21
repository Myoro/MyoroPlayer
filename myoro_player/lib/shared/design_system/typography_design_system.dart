import 'package:flutter/material.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';

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
        color: isDarkMode
            ? DarkDesignSystem.onBackground
            : LightDesignSystem.onBackground);

/// This class should not be used within the application, use [ThemeData.textTheme] instead
///
/// Three styles (regular, italic, bold) & 3 sizes (12, 16, & 20)
class TypographyDesignSystem {
  static TextStyle regularSmall(bool isDarkMode) => _textStyle(
        isDarkMode,
        fontSize: 12,
      );

  static TextStyle regularMedium(bool isDarkMode) => _textStyle(
        isDarkMode,
        fontSize: 16,
      );

  static TextStyle regularLarge(bool isDarkMode) => _textStyle(
        isDarkMode,
        fontSize: 20,
      );

  static TextStyle italicSmall(bool isDarkMode) => _textStyle(
        isDarkMode,
        fontSize: 12,
        fontStyle: FontStyle.italic,
      );

  static TextStyle italicMedium(bool isDarkMode) => _textStyle(
        isDarkMode,
        fontSize: 16,
        fontStyle: FontStyle.italic,
      );

  static TextStyle italicLarge(bool isDarkMode) => _textStyle(
        isDarkMode,
        fontSize: 20,
        fontStyle: FontStyle.italic,
      );

  static TextStyle boldSmall(bool isDarkMode) => _textStyle(
        isDarkMode,
        fontSize: 12,
        fontWeight: FontWeight.bold,
      );

  static TextStyle boldMedium(bool isDarkMode) => _textStyle(
        isDarkMode,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );

  static TextStyle boldLarge(bool isDarkMode) => _textStyle(
        isDarkMode,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );
}
