import 'package:flutter/material.dart';
import 'package:myoro_player/shared/enums/divider_type_enum.dart';
import 'package:myoro_player/shared/widgets/dividers/base_divider.dart';

class ResizeDivider extends StatelessWidget {
  final DividerTypeEnum dividerType;
  final double? padding;
  final Function(DragUpdateDetails)? onHorizontalDragUpdate;
  final Function(DragUpdateDetails)? onVerticalDragUpdate;

  const ResizeDivider({
    super.key,
    required this.dividerType,
    this.padding,
    this.onHorizontalDragUpdate,
    this.onVerticalDragUpdate,
  }) : assert(
          ((dividerType == DividerTypeEnum.vertical && onHorizontalDragUpdate != null) ||
              (dividerType == DividerTypeEnum.horizontal && onVerticalDragUpdate != null)),
          '[ResizeDivider]: '
          'If dividerType == DividerTypeEnum.vertical, onHorizontalDragUpdate must not be null.'
          'If dividerType == DividerTypeEnum.horizontal, onVerticalDragUpdate must not be null.',
        );

  @override
  Widget build(BuildContext context) => BaseDivider(
        dividerType: dividerType,
        padding: padding,
        onHorizontalDragUpdate: onHorizontalDragUpdate,
        onVerticalDragUpdate: onVerticalDragUpdate,
      );
}
