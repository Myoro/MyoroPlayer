import 'package:flutter/material.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/design_system/decoration_design_system.dart';
import 'package:frontend/shared/widgets/dividers/basic_divider.dart';

typedef DragUpdateCallback = Function(DragUpdateDetails details);

final class ResizeDivider extends StatelessWidget {
  final Axis direction;
  final DragUpdateCallback? onHorizontalDragUpdate;
  final DragUpdateCallback? onVerticalDragUpdate;
  final EdgeInsets? padding;

  const ResizeDivider({
    super.key,
    required this.direction,
    this.onHorizontalDragUpdate,
    this.onVerticalDragUpdate,
    this.padding,
  }) : assert(
          (direction == Axis.horizontal && onVerticalDragUpdate != null) || (direction == Axis.vertical && onHorizontalDragUpdate != null),
          '[ResizeDivider]: If the divider\'s [direction] is [Axis.horizontal], [onVerticalDragUpdate] must be provided'
          ' And if the divider\'s [direction] is [Axis.vertical], [onHorizontalDragUpdate] must be provided.',
        );

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
              onHorizontalDragUpdate: (details) => onHorizontalDragUpdate?.call(details),
              onVerticalDragUpdate: (details) => onVerticalDragUpdate?.call(details),
              child: Container(
                width: isHorizontal ? 25 : 10,
                height: isHorizontal ? 10 : 25,
                decoration: BoxDecoration(
                  color: ColorDesignSystem.onBackground(context),
                  borderRadius: DecorationDesignSystem.borderRadius,
                ),
              ),
            ),
          ),
        ),
        IgnorePointer(
          child: BasicDivider(
            direction: direction,
            padding: padding,
          ),
        ),
      ],
    );
  }
}
