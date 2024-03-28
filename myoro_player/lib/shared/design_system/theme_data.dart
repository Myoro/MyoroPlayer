import 'package:flutter/material.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/design_system/typography_design_system.dart';

ThemeData createTheme({required bool isDarkMode}) {
  final Color background = isDarkMode ? DarkModeColorDesignSystem.background : LightModeColorDesignSystem.background;

  return ThemeData(
    brightness: isDarkMode ? Brightness.dark : Brightness.light,
    appBarTheme: AppBarTheme(
      backgroundColor: background,
    ),
    scaffoldBackgroundColor: background,
    textTheme: TextTheme(
      // Regular fonts
      bodySmall: TypographyDesignSystem.regularSmall(isDarkMode),
      bodyMedium: TypographyDesignSystem.regularMedium(isDarkMode),
      bodyLarge: TypographyDesignSystem.regularLarge(isDarkMode),

      // Italicized fonts
      headlineSmall: TypographyDesignSystem.italicSmall(isDarkMode),
      headlineMedium: TypographyDesignSystem.italicMedium(isDarkMode),
      headlineLarge: TypographyDesignSystem.italicLarge(isDarkMode),

      // Bolded fonts
      titleSmall: TypographyDesignSystem.boldSmall(isDarkMode),
      titleMedium: TypographyDesignSystem.boldMedium(isDarkMode),
      titleLarge: TypographyDesignSystem.boldLarge(isDarkMode),
    ),
  );
}
