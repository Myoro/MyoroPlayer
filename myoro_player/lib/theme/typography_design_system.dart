import 'package:flutter/material.dart';
import 'package:myoro_player/theme/color_design_system.dart';

TextStyle _textStyle(
  BuildContext? context,
  bool isDarkMode, {
  required double fontSize,
  FontStyle fontStyle = FontStyle.normal,
  FontWeight fontWeight = FontWeight.normal,
}) =>
    TextStyle(
      color: context != null
          ? ColorDesignSystem.onBackground(context)
          : isDarkMode
              ? DarkDesignSystem.onBackground
              : LightDesignSystem.onBackground,
      fontFamily: 'Ubuntu',
      fontSize: fontSize,
      fontStyle: fontStyle,
      fontWeight: fontWeight,
    );

class TypographyDesignSystem {
  static TextStyle regularSmall({
    BuildContext? context,
    bool isDarkMode = true,
  }) =>
      _textStyle(
        context,
        isDarkMode,
        fontSize: 16,
      );

  static TextStyle regularMedium({
    BuildContext? context,
    bool isDarkMode = true,
  }) =>
      _textStyle(
        context,
        isDarkMode,
        fontSize: 20,
      );

  static TextStyle regularLarge({
    BuildContext? context,
    bool isDarkMode = true,
  }) =>
      _textStyle(
        context,
        isDarkMode,
        fontSize: 24,
      );

  static TextStyle italicSmall({
    BuildContext? context,
    bool isDarkMode = true,
  }) =>
      _textStyle(
        context,
        isDarkMode,
        fontSize: 16,
        fontStyle: FontStyle.italic,
      );

  static TextStyle italicMedium({
    BuildContext? context,
    bool isDarkMode = true,
  }) =>
      _textStyle(
        context,
        isDarkMode,
        fontSize: 20,
        fontStyle: FontStyle.italic,
      );

  static TextStyle italicLarge({
    BuildContext? context,
    bool isDarkMode = true,
  }) =>
      _textStyle(
        context,
        isDarkMode,
        fontSize: 24,
        fontStyle: FontStyle.italic,
      );

  static TextStyle boldSmall({
    BuildContext? context,
    bool isDarkMode = true,
  }) =>
      _textStyle(
        context,
        isDarkMode,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      );

  static TextStyle boldMedium({
    BuildContext? context,
    bool isDarkMode = true,
  }) =>
      _textStyle(
        context,
        isDarkMode,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      );

  static TextStyle boldLarge({
    BuildContext? context,
    bool isDarkMode = true,
  }) =>
      _textStyle(
        context,
        isDarkMode,
        fontSize: 24,
        fontWeight: FontWeight.bold,
      );
}
