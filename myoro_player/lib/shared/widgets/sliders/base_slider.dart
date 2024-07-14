import 'package:flutter/material.dart';

/// Only used class for sliders in MyoroPlayer
final class BaseSlider extends StatelessWidget {
  final double? width;
  final double? max;
  final double? value;
  final Function(double value)? onChanged;

  const BaseSlider({
    super.key,
    this.width,
    this.max,
    this.value,
    this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 25,
      child: Slider(
        min: 0,
        max: max ?? 100,
        value: value ?? 0,
        onChanged: (value) => onChanged?.call(value),
      ),
    );
  }
}
