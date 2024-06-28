import 'package:flutter/material.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/design_system/decoration_design_system.dart';
import 'package:myoro_player/shared/widgets/dividers/basic_divider.dart';

typedef ResizeDividerCallback = Function(DragUpdateDetails details);

/// Divider with callbacks for resizing
final class ResizeDivider extends StatelessWidget {
  final Axis direction;
  final ResizeDividerCallback resizeCallback;
  final EdgeInsets padding;

  const ResizeDivider({
    super.key,
    required this.direction,
    required this.resizeCallback,
    this.padding = EdgeInsets.zero,
  });

  @override
  Widget build(BuildContext context) {
    final bool isHorizontal = direction == Axis.horizontal;

    return Stack(
      alignment: Alignment.center,
      children: [
        Positioned(
          child: MouseRegion(
            cursor: isHorizontal ? SystemMouseCursors.resizeRow : SystemMouseCursors.resizeColumn,
            child: GestureDetector(
              onHorizontalDragUpdate:
                  isHorizontal ? null : (details) => resizeCallback.call(details),
              onVerticalDragUpdate: isHorizontal ? (details) => resizeCallback.call(details) : null,
              child: Container(
                width: isHorizontal ? 30 : 10,
                height: isHorizontal ? 10 : 30,
                decoration: BoxDecoration(
                  color: ColorDesignSystem.onBackground(context),
                  borderRadius: DecorationDesignSystem.borderRadius,
                ),
              ),
            ),
          ),
        ),
        IgnorePointer(
          child: Padding(
            padding: padding,
            child: BasicDivider(
              direction: direction,
            ),
          ),
        ),
      ],
    );
  }
}
