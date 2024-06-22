import 'package:flutter/material.dart';
import 'package:myoro_player/shared/extensions/build_context_extension.dart';
import 'package:myoro_player/shared/widgets/dividers/basic_divider.dart';

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
        BasicDivider(
          direction: Axis.horizontal,
          padding: const EdgeInsets.symmetric(
            horizontal: 10,
          ),
        ),
      ],
    );
  }
}
