import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/design_system/decoration_design_system.dart';

/// Class that accepts a local image, local SVG, image URL, or a blob [UInt8List]
final class BaseImage extends StatelessWidget {
  /// Local image
  final String? localImagePath;

  /// SVG
  final String? svgPath;

  /// [Color] of [svgPath]
  final Color? svgColor;

  /// Image URL
  final String? imageUrl;

  /// Blob
  final Uint8List? blob;

  /// Size of the [BaseImage]
  final double size;

  const BaseImage({
    super.key,
    this.localImagePath,
    this.svgPath,
    this.svgColor,
    this.imageUrl,
    this.blob,
    required this.size,
  }) : assert(
          (localImagePath != null) ^ (svgPath != null) ^ (imageUrl != null) ^ (blob != null),
          '[BaseImage]: An [localImagePath] xor [svgPath] xor [imageUrl] xor [blob] must be provided',
        );

  @override
  Widget build(BuildContext context) {
    late final Widget widget;

    if (localImagePath != null) {
      widget = Image.file(
        File(localImagePath!),
        width: size,
        fit: BoxFit.fitWidth,
      );
    } else if (svgPath != null) {
      widget = SizedBox(
        width: size,
        height: size,
        child: SvgPicture.file(
          File(svgPath!),
          height: size,
          fit: BoxFit.fitHeight,
          colorFilter: ColorFilter.mode(
            svgColor ?? ColorDesignSystem.onBackground(context),
            BlendMode.srcIn,
          ),
        ),
      );
      // coverage:ignore-start
    } else if (imageUrl != null) {
      widget = Image.network(
        imageUrl!,
        width: size,
        fit: BoxFit.fitWidth,
      );
    } else if (blob != null) {
      widget = Image.memory(
        blob!,
        width: size,
        fit: BoxFit.fitWidth,
      );
    }
    // coverage:ignore-end

    return ClipRRect(
      borderRadius: svgPath == null ? DecorationDesignSystem.borderRadius : BorderRadius.zero,
      child: widget,
    );
  }
}
