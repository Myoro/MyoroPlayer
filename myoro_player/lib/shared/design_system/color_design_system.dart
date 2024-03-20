import 'package:flutter/material.dart';
import 'package:myoro_player/shared/helpers/build_context_helper.dart';

class ColorDesignSystem {
  static Color get transparent => Colors.transparent;

  static Color background(BuildContext context) => context.isDarkMode
      ? DarkDesignSystem.background
      : LightDesignSystem.background;

  static Color onBackground(BuildContext context) => context.isDarkMode
      ? DarkDesignSystem.onBackground
      : LightDesignSystem.onBackground;
}

class DarkDesignSystem {
  static Color get background => const Color(0xFF181818);
  static Color get onBackground => const Color(0xFFEDE6D6);
}

class LightDesignSystem {
  static Color get background => const Color(0xFFEDE6D6);
  static Color get onBackground => const Color(0xFF181818);
}
