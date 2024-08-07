import 'package:flutter/material.dart';
import 'package:myoro_player/core/extensions/build_context_extension.dart';
import 'package:myoro_player/core/widgets/dividers/basic_divider.dart';

final class UnderlineHeader extends StatelessWidget {
  final String? header;

  const UnderlineHeader({super.key, this.header});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          header ?? '',
          style: context.textTheme.headlineMedium,
        ),
        const SizedBox(height: 3),
        const BasicDivider(
          direction: Axis.horizontal,
          padding: EdgeInsets.symmetric(
            horizontal: 10,
          ),
        ),
      ],
    );
  }
}
