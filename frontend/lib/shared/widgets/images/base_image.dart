import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/design_system/decoration_design_system.dart';

/// Class that accepts a local image, local SVG, or image URL
final class BaseImage extends StatelessWidget {
  /// Local image
  final String? localImagePath;

  /// SVG
  final String? svgPath;

  /// [Color] of [svgPath]
  final Color? svgColor;

  /// Image URL
  final String? imageUrl;

  /// Width of the [BaseImage]
  ///
  /// Height of the image is not a member as the image will always contain the aspect ratio
  final double width;

  const BaseImage({
    super.key,
    this.localImagePath,
    this.svgPath,
    this.svgColor,
    this.imageUrl,
    required this.width,
  }) : assert(
          (localImagePath != null) ^ (svgPath != null) ^ (imageUrl != null),
          '[BaseImage]: A [localImagePath] xor [svgPath] xor [imageUrl] must be provided',
        );

  @override
  Widget build(BuildContext context) {
    late final Widget widget;

    if (localImagePath != null) {
      widget = Image.file(
        File(localImagePath!),
        width: width,
        fit: BoxFit.fitWidth,
      );
    } else if (svgPath != null) {
      widget = SvgPicture.file(
        File(svgPath!),
        width: width,
        fit: BoxFit.fitWidth,
        colorFilter: ColorFilter.mode(
          svgColor ?? ColorDesignSystem.onBackground(context),
          BlendMode.srcIn,
        ),
      );
      // coverage:ignore-start
    } else if (imageUrl != null) {
      widget = Image.network(
        imageUrl!,
        width: width,
        fit: BoxFit.fitWidth,
      );
    }
    // coverage:ignore-end

    return ClipRRect(
      borderRadius: DecorationDesignSystem.borderRadius,
      child: Padding(
        padding: const EdgeInsets.all(3),
        child: widget,
      ),
    );
  }
}
