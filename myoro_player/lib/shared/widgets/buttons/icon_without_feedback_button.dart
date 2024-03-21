import 'package:flutter/material.dart';
import 'package:myoro_player/shared/enums/button_type_enum.dart';
import 'package:myoro_player/shared/widgets/buttons/base_button.dart';

class IconWithoutFeedbackButton extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final double iconSize;
  final String? tooltip;

  const IconWithoutFeedbackButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.iconSize,
    this.tooltip,
  });

  @override
  Widget build(BuildContext context) => BaseButton(
        buttonTypeEnum: ButtonTypeEnum.iconWithoutFeedbackButton,
        onTap: onTap,
        icon: icon,
        iconSize: iconSize,
        tooltip: tooltip,
      );
}
