import 'package:flutter/material.dart';
import 'package:myoro_player/design_system/color_design_system.dart';
import 'package:myoro_player/design_system/decoration_design_system.dart';
import 'package:myoro_player/enums/button_type_enum.dart';
import 'package:myoro_player/widgets/buttons/icon_without_feedback_button.dart';
import 'package:myoro_player/widgets/buttons/hover_button.dart';
import 'package:myoro_player/widgets/icons/base_svg.dart';

/// Never use this base class in code, always use it's derivations
///
/// In addition, the reason above is why this class is not widget tested
class BaseButton extends StatefulWidget {
  /// Used by all buttons
  final ButtonTypeEnum buttonType;
  final Function onTap;
  final EdgeInsets? padding;
  final String? tooltip;

  /// [IconWithoutFeedbackButton] & [HoverButton] members
  final IconData? icon;
  final String? svgPath;
  final double? iconSize; // iconSize applies to icon & svgPath
  final String? text;

  BaseButton({
    super.key,
    required this.buttonType,
    required this.onTap,
    this.padding,
    this.tooltip,
    this.icon,
    this.svgPath,
    this.iconSize,
    this.text,
  }) {
    switch (buttonType) {
      case ButtonTypeEnum.iconWithoutFeedbackButton:
        assert(
          icon != null && iconSize != null,
          '[BaseButton]: [ButtonTypeEnum.iconWithoutFeedbackButton]\'s [icon] & [iconSize] must not be null',
        );
        break;
      case ButtonTypeEnum.hoverButton:
        assert(
          ((icon != null && iconSize != null) ^ (svgPath != null && iconSize != null)) || text != null,
          '[BaseButton]: [ButtonTypeEnum.hoverButton]\'s [icon] & [iconSize] or [text] must not be null',
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
  Widget build(BuildContext context) => Tooltip(
        message: widget.tooltip ?? '',
        waitDuration: DecorationDesignSystem.tooltipWaitDuration,
        textAlign: TextAlign.center,
        child: InkWell(
          hoverColor: ColorDesignSystem.transparent,
          splashColor: ColorDesignSystem.transparent,
          highlightColor: ColorDesignSystem.transparent,
          onTap: () => widget.onTap(),
          onHover: widget.buttonType != ButtonTypeEnum.hoverButton ? null : (value) => _hovered.value = value,
          child: ValueListenableBuilder(
              valueListenable: _hovered,
              builder: (context, hovered, child) {
                late final Widget child;

                switch (widget.buttonType) {
                  case ButtonTypeEnum.iconWithoutFeedbackButton:
                    child = _IconWithoutFeedbackButton(
                      widget.onTap,
                      widget.padding,
                      widget.icon!,
                      widget.iconSize!,
                    );
                    break;
                  case ButtonTypeEnum.hoverButton:
                    child = _HoverButton(
                      hovered,
                      widget.onTap,
                      widget.padding,
                      widget.icon,
                      widget.svgPath,
                      widget.iconSize,
                      widget.text,
                    );
                    break;
                }

                return child;
              }),
        ),
      );
}

class _IconWithoutFeedbackButton extends StatelessWidget {
  final Function onTap;
  final EdgeInsets? padding;
  final IconData icon;
  final double iconSize;

  const _IconWithoutFeedbackButton(
    this.onTap,
    this.padding,
    this.icon,
    this.iconSize,
  );

  @override
  Widget build(BuildContext context) => Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Icon(
          icon,
          size: iconSize,
          color: ColorDesignSystem.onBackground(context),
        ),
      );
}

class _HoverButton extends StatelessWidget {
  final bool hovered;
  final Function onTap;
  final EdgeInsets? padding;
  final IconData? icon;
  final String? svgPath;
  final double? iconSize;
  final String? text;

  const _HoverButton(
    this.hovered,
    this.onTap,
    this.padding,
    this.icon,
    this.svgPath,
    this.iconSize,
    this.text,
  );

  @override
  Widget build(BuildContext context) {
    final Color iconAndTextColor = !hovered ? ColorDesignSystem.onBackground(context) : ColorDesignSystem.background(context);

    return Container(
      decoration: BoxDecoration(
        color: !hovered ? ColorDesignSystem.transparent : ColorDesignSystem.onBackground(context),
        borderRadius: DecorationDesignSystem.borderRadius,
      ),
      child: Padding(
        padding: padding ?? EdgeInsets.zero,
        child: Row(
          children: [
            if (icon != null)
              Icon(
                icon,
                size: iconSize,
                color: iconAndTextColor,
              ),
            if (svgPath != null)
              BaseSvg(
                svgPath: svgPath!,
                svgSize: iconSize!,
                svgColor: iconAndTextColor,
              ),
            if (icon != null && text != null) const SizedBox(width: 10),
            if (text != null)
              Expanded(
                child: Text(
                  text!,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                        color: iconAndTextColor,
                      ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
