import 'package:flutter/material.dart';
import 'package:myoro_player/enums/divider_type_enum.dart';
import 'package:myoro_player/widgets/dividers/base_divider.dart';

/// A divider without feature, just a divider
class BasicDivider extends StatelessWidget {
  final DividerTypeEnum dividerType;

  const BasicDivider({super.key, required this.dividerType});

  @override
  Widget build(BuildContext context) => BaseDivider(
        dividerType: dividerType,
      );
}
