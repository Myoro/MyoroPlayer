import 'package:flutter/material.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/extensions/build_context_extension.dart';
import 'package:frontend/shared/extensions/text_style_extension.dart';
import 'package:frontend/shared/widgets/buttons/base_hover_button.dart';

/// Button that accepts an icon, text, or both
final class IconTextHoverButton extends StatelessWidget {
  final IconData? icon;
  final double? iconSize;
  final String? text;
  final TextStyle? textStyle;
  final TextAlign textAlign;
  final EdgeInsets? padding;
  final bool bordered;
  final Function onTap;
  final Function(TapDownDetails details)? onSecondaryTapDown;

  const IconTextHoverButton({
    super.key,
    this.icon,
    this.iconSize,
    this.text,
    this.textStyle,
    this.textAlign = TextAlign.left,
    this.padding,
    this.bordered = false,
    required this.onTap,
    this.onSecondaryTapDown,
  }) : assert(
          (icon != null && iconSize != null) || text != null,
          '[IconTextHoverButton]: [icon] (with [iconSize] provided) and/or [text] must be provided.',
        );

  @override
  Widget build(BuildContext context) {
    return BaseHoverButton(
      padding: padding ?? const EdgeInsets.all(3),
      bordered: bordered,
      onTap: onTap,
      onSecondaryTapDown: onSecondaryTapDown,
      builder: (hovered) {
        // coverage:ignore-start
        final Color contentColor = hovered ? ColorDesignSystem.background(context) : ColorDesignSystem.onBackground(context);
        // coverage:ignore-end

        return Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                size: iconSize,
                color: contentColor,
              ),
            if (icon != null && text != null) const SizedBox(width: 10),
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
