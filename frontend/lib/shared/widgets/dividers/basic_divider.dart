import 'package:flutter/material.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/design_system/decoration_design_system.dart';

final class BasicDivider extends StatelessWidget {
  final Axis direction;
  final EdgeInsets? padding;

  const BasicDivider({
    super.key,
    required this.direction,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final bool isHorizontal = direction == Axis.horizontal;

    return Padding(
      padding: padding ??
          EdgeInsets.symmetric(
            horizontal: isHorizontal ? 10 : 0,
            vertical: isHorizontal ? 0 : 10,
          ),
      child: Container(
        width: isHorizontal ? double.infinity : 2,
        height: isHorizontal ? 2 : double.infinity,
        decoration: BoxDecoration(
          color: ColorDesignSystem.onBackground(context),
          borderRadius: DecorationDesignSystem.borderRadius,
        ),
      ),
    );
  }
}
