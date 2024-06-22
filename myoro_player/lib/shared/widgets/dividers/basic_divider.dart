import 'package:flutter/material.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';

final class BasicDivider extends StatelessWidget {
  final Axis direction;
  final EdgeInsets padding;

  const BasicDivider({
    super.key,
    required this.direction,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final bool isHorizontal = direction == Axis.horizontal;

    return Padding(
      padding: padding,
      child: Container(
        width: isHorizontal ? double.infinity : 2,
        height: isHorizontal ? 2 : double.infinity,
        color: ColorDesignSystem.onBackground(context),
      ),
    );
  }
}
