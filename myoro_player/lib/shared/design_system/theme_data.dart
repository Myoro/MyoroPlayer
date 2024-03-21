import 'package:flutter/material.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/design_system/typography_design_system.dart';

ThemeData createTheme({required bool isDarkMode}) {
  final Color background =
      isDarkMode ? DarkDesignSystem.background : LightDesignSystem.background;

  return ThemeData(
    brightness: isDarkMode ? Brightness.dark : Brightness.light,
    primaryColor: background,
    appBarTheme: AppBarTheme(
      backgroundColor: background,
      surfaceTintColor: background,
    ),
    scaffoldBackgroundColor: background,
    textTheme: TextTheme(
      bodySmall: TypographyDesignSystem.regularSmall(isDarkMode),
      bodyMedium: TypographyDesignSystem.regularMedium(isDarkMode),
      bodyLarge: TypographyDesignSystem.regularLarge(isDarkMode),
      headlineSmall: TypographyDesignSystem.italicSmall(isDarkMode),
      headlineMedium: TypographyDesignSystem.italicMedium(isDarkMode),
      headlineLarge: TypographyDesignSystem.italicLarge(isDarkMode),
      titleSmall: TypographyDesignSystem.boldSmall(isDarkMode),
      titleMedium: TypographyDesignSystem.boldMedium(isDarkMode),
      titleLarge: TypographyDesignSystem.boldLarge(isDarkMode),
    ),
  );
}
