import 'package:flutter/material.dart';
import 'package:myoro_player/shared/enums/button_type_enum.dart';
import 'package:myoro_player/shared/widgets/buttons/base_button.dart';

class HoverButton extends StatelessWidget {
  final Function onTap;
  final IconData? icon;
  final double? iconSize;
  final String? svgPath;
  final String? text;

  const HoverButton({
    super.key,
    required this.onTap,
    this.icon,
    this.iconSize,
    this.svgPath,
    this.text,
  });

  @override
  Widget build(BuildContext context) => BaseButton(
        buttonTypeEnum: ButtonTypeEnum.hoverButton,
        onTap: onTap,
        icon: icon,
        iconSize: iconSize,
        svgPath: svgPath,
        text: text,
      );
}
