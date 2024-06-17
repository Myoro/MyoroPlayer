import 'package:flutter/material.dart';
import 'package:frontend/shared/extensions/build_context_extension.dart';

const _primaryDarkColor = Color(0xFF181818);
const _primaryLightColor = Color(0xFFEDE6D6);

final class ColorDesignSystem {
  static const error = Colors.red;
  static const onError = Colors.white;
  static const transparent = Colors.transparent;

  static Color background(BuildContext context) {
    if (context.isDarkMode) {
      return DarkModeColorDesignSystem.background;
    } else {
      return LightModeColorDesignSystem.background;
    }
  }

  static Color onBackground(BuildContext context) {
    if (context.isDarkMode) {
      return DarkModeColorDesignSystem.onBackground;
    } else {
      return LightModeColorDesignSystem.onBackground;
    }
  }
}

final class DarkModeColorDesignSystem {
  static const background = _primaryDarkColor;
  static const onBackground = _primaryLightColor;
}

final class LightModeColorDesignSystem {
  static const background = _primaryLightColor;
  static const onBackground = _primaryLightColor;
}
