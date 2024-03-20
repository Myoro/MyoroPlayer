import 'package:flutter/material.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/enums/divider_type_enum.dart';

class BaseDivider extends StatelessWidget {
  final DividerTypeEnum dividerTypeEnum;
  final EdgeInsets? padding;

  /// For [BaseDivider]s that are being used as resize handles
  final Function(DragUpdateDetails)? onHorizontalDragUpdate;

  const BaseDivider({
    super.key,
    required this.dividerTypeEnum,
    this.padding,
    this.onHorizontalDragUpdate,
  });

  @override
  Widget build(BuildContext context) {
    late final double width;
    late final double height;

    switch (dividerTypeEnum) {
      case DividerTypeEnum.horizontal:
        width = double.infinity;
        height = 1;
        break;
      case DividerTypeEnum.vertical:
        width = 1;
        height = double.infinity;
        break;
    }

    return MouseRegion(
      cursor: onHorizontalDragUpdate != null
          ? SystemMouseCursors.resizeColumn
          : SystemMouseCursors.basic,
      child: GestureDetector(
        onHorizontalDragUpdate: onHorizontalDragUpdate != null
            ? (details) => onHorizontalDragUpdate!(details)
            : null,
        child: Padding(
          padding: padding ?? EdgeInsets.zero,
          child: Container(
            width: width,
            height: height,
            color: ColorDesignSystem.onBackground(context),
          ),
        ),
      ),
    );
  }
}
