import 'package:flutter/material.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/design_system/decoration_design_system.dart';

typedef BaseHoverButtonBuilder = Function(bool hovered);

/// An "abstract" hover button (accepts a builder so control is changed to the user of [BaseHoverButton])
final class BaseHoverButton extends StatefulWidget {
  final EdgeInsets? padding;
  final BaseHoverButtonBuilder builder;
  final Function onTap;

  const BaseHoverButton({
    super.key,
    this.padding,
    required this.builder,
    required this.onTap,
  });

  @override
  State<BaseHoverButton> createState() => _BaseHoverButtonState();
}

final class _BaseHoverButtonState extends State<BaseHoverButton> {
  BaseHoverButtonBuilder get _builder => widget.builder;
  Function get _onTap => widget.onTap;

  final _hoveredNotifier = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _hoveredNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final EdgeInsets? padding = widget.padding;

    return InkWell(
      hoverColor: ColorDesignSystem.transparent,
      splashColor: ColorDesignSystem.transparent,
      highlightColor: ColorDesignSystem.transparent,
      onTap: () => _onTap.call(),
      onHover: (value) => _hoveredNotifier.value = value,
      child: ValueListenableBuilder(
        valueListenable: _hoveredNotifier,
        builder: (context, hovered, _) {
          return Container(
            padding: padding ?? EdgeInsets.zero,
            decoration: BoxDecoration(
              color: hovered ? ColorDesignSystem.onBackground(context) : ColorDesignSystem.transparent,
              borderRadius: DecorationDesignSystem.borderRadius,
            ),
            child: _builder.call(hovered),
          );
        },
      ),
    );
  }
}
