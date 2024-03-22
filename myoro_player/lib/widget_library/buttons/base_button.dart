import 'package:flutter/material.dart';
import 'package:myoro_player/design_system/color_design_system.dart';
import 'package:myoro_player/enums/button_type_enum.dart';

class BaseButton extends StatelessWidget {
  /// Required by all buttons
  final ButtonTypeEnum buttonType;
  final Function onTap;

  /// [IconWithoutFeedback] members
  final IconData? icon;
  final double? iconSize;

  BaseButton({
    super.key,
    required this.buttonType,
    required this.onTap,
    this.icon,
    this.iconSize,
  }) {
    switch (buttonType) {
      case ButtonTypeEnum.iconWithoutFeedbackButton:
        assert(
          icon != null && iconSize != null,
          '[BaseButton]: [ButtonTypeEnum.iconWithoutFeedbackButton]\'s [icon] & [iconSize] must not be null',
        );
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    late final Widget widget;

    switch (buttonType) {
      case ButtonTypeEnum.iconWithoutFeedbackButton:
        widget = _IconWithoutFeedbackButton(
          onTap,
          icon!,
          iconSize!,
        );
        break;
    }

    return InkWell(
      hoverColor: ColorDesignSystem.transparent,
      splashColor: ColorDesignSystem.transparent,
      highlightColor: ColorDesignSystem.transparent,
      onTap: () => onTap(),
      child: widget,
    );
  }
}

class _IconWithoutFeedbackButton extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final double iconSize;

  const _IconWithoutFeedbackButton(
    this.onTap,
    this.icon,
    this.iconSize,
  );

  @override
  Widget build(BuildContext context) => Icon(
        icon,
        size: iconSize,
        color: ColorDesignSystem.onBackground(context),
      );
}
