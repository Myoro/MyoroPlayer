import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class BaseSvg extends StatelessWidget {
  final String svgPath;
  final double svgSize;
  final Color svgColor;

  const BaseSvg({
    super.key,
    required this.svgPath,
    required this.svgSize,
    required this.svgColor,
  });

  @override
  Widget build(BuildContext context) => SvgPicture.asset(
        svgPath,
        width: svgSize,
        height: svgSize,
        colorFilter: ColorFilter.mode(
          svgColor,
          BlendMode.srcIn,
        ),
      );
}
