import 'package:flutter/material.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/design_system/decoration_design_system.dart';
import 'package:myoro_player/shared/enums/divider_type_enum.dart';
import 'package:myoro_player/shared/widgets/dividers/resize_divider.dart';

class BaseDivider extends StatelessWidget {
  /// If [BaseDivider] is a horizontal or vertical divider
  final DividerTypeEnum dividerTypeEnum;

  /// Padding of the transparent [Container]
  ///
  /// Using [Padding] instead of this [Container] causes problems when using [onHorizontalDragUpdate]
  final double? padding;

  /// For [BaseDivider]s that are being used as resize handles ([ResizeDivider])
  final Function(DragUpdateDetails)? onHorizontalDragUpdate;
  final Function(DragUpdateDetails)? onVerticalDragUpdate;

  const BaseDivider({
    super.key,
    required this.dividerTypeEnum,
    this.padding,
    this.onHorizontalDragUpdate,
    this.onVerticalDragUpdate,
  }) : assert(
          (onHorizontalDragUpdate == null && onVerticalDragUpdate == null) ||
              (dividerTypeEnum == DividerTypeEnum.vertical &&
                  onHorizontalDragUpdate != null) ||
              (dividerTypeEnum == DividerTypeEnum.horizontal &&
                  onVerticalDragUpdate != null),
          '''
      [BaseDivider]: Assertion error:
      1. For non-resize dividers, [onHorizontalDragUpdate] & [onVerticalDragUpdate] must be null
      2. For resize dividers:
      - dividerTypeEnum must be DividerTypeEnum.vertical && onHorizontalDragUpdate must not be null
      - dividerTypeEnum must be DividerTypeEnum.horizontal && onVerticalDragUpdate must not be null
    ''',
        );

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onHorizontalDragUpdate: onHorizontalDragUpdate != null
          ? (details) => onHorizontalDragUpdate!(details)
          : null,
      onVerticalDragUpdate: onVerticalDragUpdate != null
          ? (details) => onVerticalDragUpdate!(details)
          : null,
      child: MouseRegion(
        cursor: onHorizontalDragUpdate != null
            ? SystemMouseCursors.resizeColumn
            : SystemMouseCursors.basic,
        child: Container(
          width: padding,
          color: ColorDesignSystem.background(context),
          child: LayoutBuilder(builder: (context, constraints) {
            late final double width;
            late final double height;

            switch (dividerTypeEnum) {
              case DividerTypeEnum.horizontal:
                width = constraints.maxWidth - 10;
                height = 2;
                break;
              case DividerTypeEnum.vertical:
                width = 2;
                height = constraints.maxHeight - 10;
                break;
            }

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                    vertical:
                        dividerTypeEnum == DividerTypeEnum.vertical ? 5 : 0,
                    horizontal:
                        dividerTypeEnum == DividerTypeEnum.horizontal ? 5 : 0,
                  ),
                  child: Container(
                    width: width,
                    height: height,
                    decoration: BoxDecoration(
                      color: ColorDesignSystem.onBackground(context),
                      borderRadius: DecorationDesignSystem.borderRadius,
                    ),
                  ),
                ),
              ],
            );
          }),
        ),
      ),
    );
  }
}
