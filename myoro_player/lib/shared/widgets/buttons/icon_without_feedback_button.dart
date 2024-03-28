import 'package:flutter/material.dart';
import 'package:myoro_player/shared/enums/button_type_enum.dart';
import 'package:myoro_player/shared/widgets/buttons/base_button.dart';

class IconWithoutFeedbackButton extends StatelessWidget {
  final Function onTap;
  final String? tooltip;
  final IconData icon;
  final double iconSize;
  final EdgeInsets? padding;

  const IconWithoutFeedbackButton({
    super.key,
    required this.onTap,
    this.tooltip,
    required this.icon,
    required this.iconSize,
    this.padding,
  });

  @override
  Widget build(BuildContext context) => BaseButton(
        buttonType: ButtonTypeEnum.iconWithoutFeedbackButton,
        onTap: onTap,
        tooltip: tooltip,
        icon: icon,
        iconSize: iconSize,
        padding: padding,
      );
}
