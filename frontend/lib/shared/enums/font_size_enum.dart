import 'package:frontend/shared/design_system/typography_design_system.dart';

/// Provided the 3 font sizes for fonts within [TypographyDesignSystem]
enum FontSizeEnum {
  small(16),
  medium(20),
  large(24);

  final double size;

  const FontSizeEnum(this.size);
}
