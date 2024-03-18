import 'package:flutter/material.dart';
import 'package:myoro_player/theme/color_design_system.dart';
import 'package:myoro_player/widgets/buttons/icon_button_without_feedback.dart';

class BaseButton extends StatelessWidget {
  final Function onTap;

  /// For [IconButtonWithoutFeedback]
  final IconData? icon;
  final double? iconSize;

  const BaseButton({
    super.key,
    required this.onTap,
    this.icon,
    this.iconSize,
  }) : assert(

            /// [IconButtonWithoutFeedback]
            icon != null ? iconSize != null : iconSize == null);

  @override
  Widget build(BuildContext context) => InkWell(
        hoverColor: ColorDesignSystem.transparent,
        splashColor: ColorDesignSystem.transparent,
        highlightColor: ColorDesignSystem.transparent,
        onTap: () => onTap(),
        child: icon != null
            ? Icon(
                icon,
                size: iconSize,
                color: ColorDesignSystem.onBackground(context),
              )
            : Container(color: Colors.pink), // TODO
      );
}
