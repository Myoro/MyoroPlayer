import 'package:flutter/material.dart';
import 'package:myoro_player/enums/button_type_enum.dart';
import 'package:myoro_player/widget_library/buttons/base_button.dart';

class IconWithoutFeedbackButton extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final double iconSize;

  const IconWithoutFeedbackButton({
    super.key,
    required this.onTap,
    required this.icon,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) => BaseButton(
        buttonType: ButtonTypeEnum.iconWithoutFeedbackButton,
        onTap: onTap,
        icon: icon,
        iconSize: iconSize,
      );
}
