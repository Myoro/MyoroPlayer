import 'package:flutter/material.dart';
import 'package:myoro_player/shared/helpers/build_context_helper.dart';

const Color _primaryDarkColor = Color(0xFF181818);
const Color _primaryLightColor = Color(0xFFEDE6D6);

class ColorDesignSystem {
  static Color get transparent => Colors.transparent;

  static Color background(BuildContext context) => context.isDarkMode ? DarkModeColorDesignSystem.background : LightModeColorDesignSystem.background;

  static Color onBackground(BuildContext context) => context.isDarkMode ? DarkModeColorDesignSystem.onBackground : LightModeColorDesignSystem.onBackground;
}

class DarkModeColorDesignSystem {
  static Color get background => _primaryDarkColor;
  static Color get onBackground => _primaryLightColor;
}

class LightModeColorDesignSystem {
  static Color get background => _primaryLightColor;
  static Color get onBackground => _primaryDarkColor;
}
