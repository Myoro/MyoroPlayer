import 'package:flutter/material.dart';
import 'package:myoro_player/enums/button_type_enum.dart';
import 'package:myoro_player/widgets/buttons/base_button.dart';

class HoverButton extends StatelessWidget {
  final Function onTap;
  final EdgeInsets? padding;
  final String? tooltip;
  final IconData? icon;
  final String? svgPath;
  final double? iconSize;
  final String? text;

  const HoverButton({
    super.key,
    required this.onTap,
    this.tooltip,
    this.padding,
    this.icon,
    this.svgPath,
    this.iconSize,
    this.text,
  });

  @override
  Widget build(BuildContext context) => BaseButton(
        buttonType: ButtonTypeEnum.hoverButton,
        onTap: onTap,
        tooltip: tooltip,
        padding: padding,
        icon: icon,
        svgPath: svgPath,
        iconSize: iconSize,
        text: text,
      );
}
