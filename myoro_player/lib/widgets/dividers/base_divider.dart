import 'package:flutter/material.dart';
import 'package:myoro_player/design_system/color_design_system.dart';
import 'package:myoro_player/design_system/decoration_design_system.dart';
import 'package:myoro_player/enums/divider_type_enum.dart';
import 'package:myoro_player/widgets/dividers/resize_divider.dart';

/// Never use this base class in code, always use it's derivations
///
/// In addition, the reason above is why this class is not widget tested
class BaseDivider extends StatelessWidget {
  /// Used by all dividers
  final DividerTypeEnum dividerType;

  /// Not [EdgeInsets] as the area of [Padding] wouldn't work to use resizing features
  final double? padding;

  /// For [ResizeDivider]
  final Function(DragUpdateDetails)? onHorizontalDragUpdate;
  final Function(DragUpdateDetails)? onVerticalDragUpdate;

  const BaseDivider({
    super.key,
    required this.dividerType,
    this.padding,
    this.onHorizontalDragUpdate,
    this.onVerticalDragUpdate,
  });

  @override
  Widget build(BuildContext context) {
    late final MouseCursor cursor;

    if (onHorizontalDragUpdate != null) {
      cursor = SystemMouseCursors.resizeColumn;
    } else if (onVerticalDragUpdate != null) {
      cursor = SystemMouseCursors.resizeRow;
    } else {
      cursor = SystemMouseCursors.basic;
    }

    return MouseRegion(
      cursor: cursor,
      child: GestureDetector(
        onHorizontalDragUpdate: onHorizontalDragUpdate == null ? null : (details) => onHorizontalDragUpdate!(details),
        onVerticalDragUpdate: onVerticalDragUpdate == null ? null : (details) => onVerticalDragUpdate!(details),
        child: Container(
          width: dividerType == DividerTypeEnum.vertical ? padding : null,
          height: dividerType == DividerTypeEnum.horizontal ? padding : null,
          color: ColorDesignSystem.transparent,
          child: LayoutBuilder(
            builder: (context, constraints) => Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Container(
                      width: dividerType == DividerTypeEnum.horizontal ? constraints.maxWidth : 2,
                      height: dividerType == DividerTypeEnum.horizontal ? 2 : constraints.maxHeight,
                      // : constraints.maxHeight,
                      decoration: BoxDecoration(
                        color: ColorDesignSystem.onBackground(context),
                        borderRadius: DecorationDesignSystem.borderRadius,
                      ),
                    ),
                    if (onHorizontalDragUpdate != null || onVerticalDragUpdate != null)
                      Positioned(
                        child: Container(
                          width: dividerType == DividerTypeEnum.horizontal ? 15 : 10,
                          height: dividerType == DividerTypeEnum.vertical ? 15 : 10,
                          decoration: BoxDecoration(
                            color: ColorDesignSystem.onBackground(context),
                            borderRadius: DecorationDesignSystem.borderRadius,
                          ),
                        ),
                      ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
