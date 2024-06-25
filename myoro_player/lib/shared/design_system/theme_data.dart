import 'package:flutter/material.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/enums/font_size_enum.dart';

TextStyle _textStyle(
  bool isDarkMode, {
  required FontSizeEnum fontSize,
  FontStyle fontStyle = FontStyle.normal,
  FontWeight fontWeight = FontWeight.normal,
}) {
  return TextStyle(
    fontFamily: 'Ubuntu',
    fontSize: fontSize.size,
    fontStyle: fontStyle,
    fontWeight: fontWeight,
    color: isDarkMode ? DarkModeColorDesignSystem.onBackground : LightModeColorDesignSystem.onBackground,
  );
}

ThemeData createTheme(bool isDarkMode) {
  final brightness = isDarkMode ? Brightness.dark : Brightness.light;
  final background = isDarkMode ? DarkModeColorDesignSystem.background : LightModeColorDesignSystem.background;
  final onBackground = isDarkMode ? DarkModeColorDesignSystem.onBackground : LightModeColorDesignSystem.onBackground;

  return ThemeData(
    brightness: brightness,
    // Used to set default colors throughout the application
    colorScheme: ColorScheme(
      background: background,
      onBackground: onBackground,
      brightness: brightness,
      primary: background,
      onPrimary: onBackground,
      secondary: background,
      onSecondary: onBackground,
      error: ColorDesignSystem.error,
      onError: ColorDesignSystem.onError,
      surface: background,
      onSurface: onBackground,
    ),
    // 3 font types (regular (body), italic (headline), & bold (title))
    // 3 font sizes ([FontSizeEnum])
    textTheme: TextTheme(
      bodySmall: _textStyle(
        isDarkMode,
        fontSize: FontSizeEnum.small,
      ),
      bodyMedium: _textStyle(
        isDarkMode,
        fontSize: FontSizeEnum.medium,
      ),
      bodyLarge: _textStyle(
        isDarkMode,
        fontSize: FontSizeEnum.large,
      ),
      headlineSmall: _textStyle(
        isDarkMode,
        fontSize: FontSizeEnum.small,
        fontStyle: FontStyle.italic,
      ),
      headlineMedium: _textStyle(
        isDarkMode,
        fontSize: FontSizeEnum.medium,
        fontStyle: FontStyle.italic,
      ),
      headlineLarge: _textStyle(
        isDarkMode,
        fontSize: FontSizeEnum.large,
        fontStyle: FontStyle.italic,
      ),
      titleSmall: _textStyle(
        isDarkMode,
        fontSize: FontSizeEnum.small,
        fontWeight: FontWeight.bold,
      ),
      titleMedium: _textStyle(
        isDarkMode,
        fontSize: FontSizeEnum.medium,
        fontWeight: FontWeight.bold,
      ),
      titleLarge: _textStyle(
        isDarkMode,
        fontSize: FontSizeEnum.large,
        fontWeight: FontWeight.bold,
      ),
    ),
    // For [BaseSlider]
    sliderTheme: SliderThemeData(
      thumbColor: onBackground,
      thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
      activeTrackColor: onBackground,
      inactiveTrackColor: Colors.grey,
      overlayShape: SliderComponentShape.noOverlay,
      overlayColor: ColorDesignSystem.transparent,
    ),
  );
}
