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
  final EdgeInsets? padding;
  final Function onTap;

  const IconTextHoverButton({
    super.key,
    this.icon,
    this.iconSize,
    this.text,
    this.textStyle,
    this.padding,
    required this.onTap,
  }) : assert(
          (icon != null && iconSize != null) || text != null,
          '[IconTextHoverButton]: [icon] (with [iconSize] provided) and/or [text] must be provided.',
        );

  @override
  Widget build(BuildContext context) {
    return BaseHoverButton(
      padding: padding ?? const EdgeInsets.all(3),
      onTap: onTap,
      builder: (hovered) {
        final Color contentColor = hovered
            ? ColorDesignSystem.background(context)
            : ColorDesignSystem.onBackground(context);

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
