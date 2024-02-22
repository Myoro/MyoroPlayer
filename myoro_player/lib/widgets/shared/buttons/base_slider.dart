import 'package:flutter/material.dart';

class BaseSlider extends StatelessWidget {
  final double width;

  const BaseSlider({
    super.key,
    required this.width,
  });

  @override
  Widget build(BuildContext context) {
    final Color onPrimary = Theme.of(context).colorScheme.onPrimary;

    return SizedBox(
      width: width,
      child: Slider(
        value: 0.5,
        onChanged: (value) => print(value),
        activeColor: onPrimary,
        inactiveColor: onPrimary.withOpacity(0.5),
      ),
    );
  }
}
