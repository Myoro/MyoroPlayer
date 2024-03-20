import 'package:flutter/material.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/design_system/decoration_design_system.dart';
import 'package:myoro_player/shared/enums/button_type_enum.dart';
import 'package:myoro_player/shared/widgets/buttons/hover_button.dart';
import 'package:myoro_player/shared/widgets/buttons/icon_without_feedback_button.dart';

class BaseButton extends StatefulWidget {
  /// Every [BaseButton] needs this
  final ButtonTypeEnum buttonTypeEnum;
  final Function onTap;

  /// [IconWithoutFeedbackButton] & [HoverButton] section
  final IconData? icon;
  final double? iconSize;

  /// [HoverButton] section
  final String? text;

  BaseButton({
    super.key,
    required this.buttonTypeEnum,
    required this.onTap,
    this.icon,
    this.iconSize,
    this.text,
  }) {
    switch (buttonTypeEnum) {
      case ButtonTypeEnum.iconWithoutFeedbackButton:
        assert(
          icon != null && iconSize != null,
          '[BaseButton]: [ButtonTypeEnum.iconWithoutFeedbackButton] assertion error',
        );
        break;
      case ButtonTypeEnum.hoverButton:
        assert(
          text != null || (icon != null && iconSize != null),
          '[BaseButton]: [ButtonTypeEnum.hoverButton] assertion error',
        );
    }
  }

  @override
  State<BaseButton> createState() => _BaseButtonState();
}

class _BaseButtonState extends State<BaseButton> {
  final ValueNotifier<bool> _hovered = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _hovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: ColorDesignSystem.transparent,
      splashColor: ColorDesignSystem.transparent,
      highlightColor: ColorDesignSystem.transparent,
      onTap: () => widget.onTap(),
      onHover: widget.buttonTypeEnum != ButtonTypeEnum.hoverButton
          ? null
          : (value) => _hovered.value = value,
      child: ValueListenableBuilder(
          valueListenable: _hovered,
          builder: (context, hovered, child) {
            late final Widget child;

            switch (widget.buttonTypeEnum) {
              case ButtonTypeEnum.iconWithoutFeedbackButton:
                child = _IconWithoutFeedbackButton(
                    widget.onTap, widget.icon!, widget.iconSize!);
                break;
              case ButtonTypeEnum.hoverButton:
                child = _HoverButton(hovered, widget.onTap, widget.icon,
                    widget.iconSize, widget.text);
                break;
            }

            return child;
          }),
    );
  }
}

class _IconWithoutFeedbackButton extends StatelessWidget {
  final Function onTap;
  final IconData icon;
  final double iconSize;

  const _IconWithoutFeedbackButton(this.onTap, this.icon, this.iconSize);

  @override
  Widget build(BuildContext context) => Icon(
        icon,
        size: iconSize,
        color: ColorDesignSystem.onBackground(context),
      );
}

class _HoverButton extends StatelessWidget {
  final bool hovered;
  final Function onTap;
  final IconData? icon;
  final double? iconSize;
  final String? text;

  const _HoverButton(
      this.hovered, this.onTap, this.icon, this.iconSize, this.text);

  @override
  Widget build(BuildContext context) => Container(
        decoration: BoxDecoration(
          color: !hovered
              ? ColorDesignSystem.transparent
              : ColorDesignSystem.onBackground(context),
          borderRadius: DecorationDesignSystem.borderRadius,
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Text(
            'Work',
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodySmall!.copyWith(
                  color: !hovered
                      ? ColorDesignSystem.onBackground(context)
                      : ColorDesignSystem.background(context),
                ),
          ),
        ),
      );
}
