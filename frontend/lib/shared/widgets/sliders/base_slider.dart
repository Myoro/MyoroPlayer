import 'package:flutter/material.dart';

/// Only used class for sliders in MyoroPlayer
final class BaseSlider extends StatelessWidget {
  final double? width;

  const BaseSlider({super.key, this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      height: 25,
      child: Slider(
        min: 0,
        max: 100,
        value: 50,
        onChanged: (_) => print(_),
      ),
    );
  }
}
