import 'package:flutter/material.dart';
import 'package:myoro_player/shared/enums/divider_type_enum.dart';
import 'package:myoro_player/shared/widgets/dividers/base_divider.dart';
import 'package:myoro_player/shared/widgets/dividers/resize_divider.dart';

class BasicDivider extends StatelessWidget {
  final DividerTypeEnum dividerTypeEnum;

  /// Padding of the transparent [Container]
  ///
  /// Using [Padding] instead of this [Container] causes problems when using [onHorizontalDragUpdate] within [ResizeDivider]s
  final double? padding;

  const BasicDivider({
    super.key,
    required this.dividerTypeEnum,
    this.padding,
  });

  @override
  Widget build(BuildContext context) => BaseDivider(
        dividerTypeEnum: dividerTypeEnum,
        padding: padding,
      );
}
