import 'package:flutter/material.dart';
import 'package:myoro_player/widgets/buttons/base_button.dart';

class IconButtonWithoutFeedback extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final double iconSize;

  const IconButtonWithoutFeedback({
    super.key,
    required this.onTap,
    required this.icon,
    required this.iconSize,
  });

  @override
  Widget build(BuildContext context) => BaseButton(
        onTap: onTap,
        icon: icon,
        iconSize: iconSize,
      );
}
