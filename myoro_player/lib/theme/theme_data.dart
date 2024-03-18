import 'package:flutter/material.dart';
import 'package:myoro_player/theme/color_design_system.dart';
import 'package:myoro_player/theme/typography_design_system.dart';

ThemeData createTheme({required bool isDarkMode}) {
  final Color background =
      isDarkMode ? DarkDesignSystem.background : LightDesignSystem.background;

  return ThemeData(
    brightness: isDarkMode ? Brightness.dark : Brightness.light,
    appBarTheme: AppBarTheme(backgroundColor: background),
    scaffoldBackgroundColor: background,
    textTheme: TextTheme(
      // Normal fonts
      bodySmall: TypographyDesignSystem.regularSmall(isDarkMode: isDarkMode),
      bodyMedium: TypographyDesignSystem.regularMedium(isDarkMode: isDarkMode),
      bodyLarge: TypographyDesignSystem.regularLarge(isDarkMode: isDarkMode),

      // Italicized fonts
      headlineSmall: TypographyDesignSystem.italicSmall(isDarkMode: isDarkMode),
      headlineMedium:
          TypographyDesignSystem.italicMedium(isDarkMode: isDarkMode),
      headlineLarge: TypographyDesignSystem.italicLarge(isDarkMode: isDarkMode),

      // Bolded fonts
      titleSmall: TypographyDesignSystem.boldSmall(isDarkMode: isDarkMode),
      titleMedium: TypographyDesignSystem.boldMedium(isDarkMode: isDarkMode),
      titleLarge: TypographyDesignSystem.boldLarge(isDarkMode: isDarkMode),
    ),
  );
}
