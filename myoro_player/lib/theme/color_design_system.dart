import 'package:flutter/material.dart';
import 'package:myoro_player/helpers/build_context_helper.dart';

const Color _primaryDarkColor = Color(0xFF181818);
const Color _primaryLightColor = Color(0xFFEDE6D6);

class ColorDesignSystem {
  static Color background(BuildContext context) => context.isDarkMode
      ? DarkDesignSystem.background
      : LightDesignSystem.background;

  static Color onBackground(BuildContext context) => context.isDarkMode
      ? DarkDesignSystem.onBackground
      : LightDesignSystem.onBackground;
}

class LightDesignSystem {
  static Color get background => _primaryLightColor;
  static Color get onBackground => _primaryDarkColor;
}

class DarkDesignSystem {
  static Color get background => _primaryDarkColor;
  static Color get onBackground => _primaryLightColor;
}
