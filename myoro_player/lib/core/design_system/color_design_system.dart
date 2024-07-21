import 'package:flutter/material.dart';
import 'package:myoro_player/core/extensions/build_context_extension.dart';

const _primaryDarkColor = Color(0xFF002244);
const _primaryLightColor = Color(0xFFFFF5EE);

final class ColorDesignSystem {
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

  static const error = Color(0xFFF88379);
  static const onError = Colors.white;
  static const transparent = Colors.transparent;
}

final class DarkModeColorDesignSystem {
  static const background = _primaryDarkColor;
  static const onBackground = _primaryLightColor;
}

final class LightModeColorDesignSystem {
  static const background = _primaryLightColor;
  static const onBackground = _primaryDarkColor;
}
