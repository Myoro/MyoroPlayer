import 'package:flutter/material.dart';
import 'package:myoro_player/shared/enums/divider_type_enum.dart';
import 'package:myoro_player/shared/widgets/dividers/base_divider.dart';

class ResizeDivider extends StatelessWidget {
  /// If [ResizeDivider] is a horizontal or vertical divider
  final DividerTypeEnum dividerTypeEnum;

  /// Padding of the transparent [Container]
  ///
  /// Using [Padding] instead of this [Container] causes problems when using [onHorizontalDragUpdate]
  final double? padding;

  final Function(DragUpdateDetails)? onHorizontalDragUpdate;
  final Function(DragUpdateDetails)? onVerticalDragUpdate;

  const ResizeDivider({
    super.key,
    required this.dividerTypeEnum,
    this.padding,
    this.onHorizontalDragUpdate,
    this.onVerticalDragUpdate,
  });

  @override
  Widget build(BuildContext context) => BaseDivider(
        dividerTypeEnum: dividerTypeEnum,
        padding: padding,
        onHorizontalDragUpdate: onHorizontalDragUpdate,
        onVerticalDragUpdate: onVerticalDragUpdate,
      );
}
