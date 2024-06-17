import 'package:frontend/shared/design_system/typography_design_system.dart';

/// Provided the 3 font sizes for fonts within [TypographyDesignSystem]
enum FontSizeEnum {
  small(12),
  medium(16),
  large(20);

  final double size;

  const FontSizeEnum(this.size);
}
