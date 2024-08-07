import 'package:flutter/material.dart';
import 'package:myoro_player/core/design_system/color_design_system.dart';
import 'package:myoro_player/core/extensions/build_context_extension.dart';
import 'package:myoro_player/core/extensions/text_style_extension.dart';
import 'package:myoro_player/core/widgets/buttons/base_hover_button.dart';
import 'package:myoro_player/core/widgets/images/base_image.dart';

/// Button that accepts an icon (this includes [IconData], SVGs, & local images), text, or both
final class IconTextHoverButton extends StatelessWidget {
  final IconData? icon;
  final String? svgPath;
  final String? localImagePath;
  final double? iconSize;
  final String? text;
  final TextStyle? textStyle;
  final TextAlign textAlign;
  final EdgeInsets? padding;
  final bool bordered;
  final bool forceHover;
  final Function onTap;
  final Function(TapDownDetails details)? onSecondaryTapDown;
  final Function? onLongPress;

  const IconTextHoverButton({
    super.key,
    this.icon,
    this.svgPath,
    this.localImagePath,
    this.iconSize,
    this.text,
    this.textStyle,
    this.textAlign = TextAlign.left,
    this.padding,
    this.bordered = false,
    this.forceHover = false,
    required this.onTap,
    this.onSecondaryTapDown,
    this.onLongPress,
  }) : assert(
          (((icon != null) ^ (svgPath != null) ^ (localImagePath != null)) && iconSize != null) || text != null,
          '[IconTextHoverButton]: [icon] xor [svgPath] xor [localImagePath] (with [iconSize] provided) and/or [text] must be provided.',
        );

  @override
  Widget build(BuildContext context) {
    return BaseHoverButton(
      padding: padding ?? const EdgeInsets.all(3),
      bordered: bordered,
      forceHover: forceHover,
      onTap: onTap,
      onSecondaryTapDown: onSecondaryTapDown,
      onLongPress: onLongPress,
      builder: (hovered) {
        // coverage:ignore-start
        final Color contentColor = forceHover
            ? ColorDesignSystem.background(context)
            : hovered
                ? ColorDesignSystem.background(context)
                : ColorDesignSystem.onBackground(context);
        // coverage:ignore-end

        return Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                size: iconSize,
                color: contentColor,
              ),
            if ((localImagePath != null) ^ (svgPath != null))
              BaseImage(
                svgPath: svgPath,
                svgColor: contentColor,
                localImagePath: localImagePath,
                size: iconSize!,
              ),
            if (((icon != null) ^ (svgPath != null) ^ (localImagePath != null)) && text != null) const SizedBox(width: 10),
            if (text != null)
              Expanded(
                child: Text(
                  text!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: textAlign,
                  style: (textStyle ?? context.textTheme.bodyMedium)?.withColor(
                    contentColor,
                  ),
                ),
              ),
          ],
        );
      },
    );
  }
}
