import 'package:flutter/material.dart';
import 'package:myoro_player/core/design_system/color_design_system.dart';
import 'package:myoro_player/core/design_system/decoration_design_system.dart';
import 'package:myoro_player/core/widgets/buttons/icon_text_hover_button.dart';

typedef HoverButtonBuilder = Function(bool hovered);

/// Used for making a hover button with any type of widget inside (unlike [IconTextHoverButton] for example)
final class BaseHoverButton extends StatefulWidget {
  /// Padding of [BaseHoverButton]
  final EdgeInsets padding;

  /// If [BaseHoverButton] has an outline border
  final bool bordered;

  /// If [BaseHoverButton] should been in a static hover state
  final bool forceHover;

  /// If [BaseHoverButton] should have no background hovering effectings
  final bool disableHover;

  /// [BaseHoverButton]'s tap callback
  final Function onTap;

  /// [BaseHoverButton]'s secondary tap callback
  final Function(TapDownDetails details)? onSecondaryTapDown;

  /// [BaseHoverButton]'s long press callback
  final Function? onLongPress;

  /// [BaseHoverButton]'s content builder
  final HoverButtonBuilder builder;

  const BaseHoverButton({
    super.key,
    this.padding = EdgeInsets.zero,
    this.bordered = false,
    this.forceHover = false,
    this.disableHover = false,
    required this.onTap,
    this.onSecondaryTapDown,
    this.onLongPress,
    required this.builder,
  });

  @override
  State<BaseHoverButton> createState() => _BaseHoverButtonState();
}

final class _BaseHoverButtonState extends State<BaseHoverButton> {
  EdgeInsets get _padding => widget.padding;
  bool get _bordered => widget.bordered;
  bool get _forceHover => widget.forceHover;
  bool get _disableHover => widget.disableHover;
  Function get _onTap => widget.onTap;
  Function(TapDownDetails details)? get _onSecondaryTapDown => widget.onSecondaryTapDown;
  Function? get _onLongPress => widget.onLongPress;
  HoverButtonBuilder get _builder => widget.builder;

  final _hoverNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _hoverNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final Color onBackground = ColorDesignSystem.onBackground(context);

    return InkWell(
      hoverColor: ColorDesignSystem.transparent,
      splashColor: ColorDesignSystem.transparent,
      highlightColor: ColorDesignSystem.transparent,
      onTap: () => _onTap.call(),
      onSecondaryTapDown: (details) => _onSecondaryTapDown?.call(details),
      onLongPress: () => _onLongPress?.call(),
      // coverage:ignore-start
      onHover: (value) => _hoverNotifier.value = value,
      // coverage:ignore-end
      child: ValueListenableBuilder(
        valueListenable: _hoverNotifier,
        builder: (context, hovered, child) {
          return Container(
            padding: _padding,
            decoration: BoxDecoration(
              borderRadius: DecorationDesignSystem.borderRadius,
              border: Border.all(
                width: _bordered ? 2 : 0,
                color: _bordered ? onBackground : ColorDesignSystem.transparent,
              ),
              // coverage:ignore-start
              color: _disableHover
                  ? ColorDesignSystem.transparent
                  : _forceHover
                      ? onBackground
                      : hovered
                          ? onBackground
                          : ColorDesignSystem.background(context),
              // coverage:ignore-end
            ),
            child: _builder.call(hovered),
          );
        },
      ),
    );
  }
}
