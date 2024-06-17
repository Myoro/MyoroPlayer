import 'package:flutter/material.dart';
import 'package:frontend/shared/design_system/typography_design_system.dart';
import 'package:frontend/shared/widgets/dividers/basic_divider.dart';

final class UnderlineTitle extends StatelessWidget {
  final String? text;

  const UnderlineTitle({super.key, required this.text});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          text ?? '',
          style: TypographyDesignSystem.headlineMedium,
        ),
        const SizedBox(height: 5),
        const BasicDivider(direction: Axis.horizontal),
      ],
    );
  }
}
