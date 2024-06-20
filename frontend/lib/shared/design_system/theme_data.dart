import 'package:flutter/material.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';

ThemeData createTheme(bool isDarkMode) {
  final Color background = isDarkMode ? DarkModeColorDesignSystem.background : LightModeColorDesignSystem.background;
  final Color onBackground = isDarkMode ? DarkModeColorDesignSystem.onBackground : LightModeColorDesignSystem.onBackground;

  return ThemeData(
    colorScheme: ColorScheme(
      brightness: isDarkMode ? Brightness.dark : Brightness.light,
      primary: background,
      onPrimary: onBackground,
      secondary: background,
      onSecondary: onBackground,
      error: ColorDesignSystem.error,
      onError: ColorDesignSystem.onError,
      surface: background,
      onSurface: onBackground,
    ),
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
