import 'package:flutter/material.dart';
import 'package:frontend/shared/enums/font_size_enum.dart';

/// Always use this class for fonts, not [Theme.of(context)]
///
/// Typography within MyoroPlayer consists of:
/// 1. 3 font categories (regular (body), italic (headline), & bold (title))
/// 2. 3 font sizes for each category ([FontSizeEnum])
final class TypographyDesignSystem {
  static final bodySmall = _style(
    fontSize: FontSizeEnum.small.size,
  );

  static final bodyMedium = _style(
    fontSize: FontSizeEnum.medium.size,
  );

  static final bodyLarge = _style(
    fontSize: FontSizeEnum.large.size,
  );

  static final headlineSmall = _style(
    fontSize: FontSizeEnum.small.size,
    fontStyle: FontStyle.italic,
  );

  static final headlineMedium = _style(
    fontSize: FontSizeEnum.medium.size,
    fontStyle: FontStyle.italic,
  );

  static final headlineLarge = _style(
    fontSize: FontSizeEnum.large.size,
    fontStyle: FontStyle.italic,
  );

  static final titleSmall = _style(
    fontSize: FontSizeEnum.small.size,
    fontWeight: FontWeight.bold,
  );

  static final titleMedium = _style(
    fontSize: FontSizeEnum.medium.size,
    fontWeight: FontWeight.bold,
  );

  static final titleLarge = _style(
    fontSize: FontSizeEnum.large.size,
    fontWeight: FontWeight.bold,
  );
}

TextStyle _style({
  required double fontSize,
  FontWeight fontWeight = FontWeight.normal,
  FontStyle fontStyle = FontStyle.normal,
}) {
  return TextStyle(
    fontFamily: 'Ubuntu',
    fontSize: fontSize,
    fontWeight: fontWeight,
    fontStyle: fontStyle,
  );
}
