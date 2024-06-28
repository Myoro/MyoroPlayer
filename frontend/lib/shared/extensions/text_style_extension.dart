import 'package:flutter/material.dart';

extension TextStyleExtension on TextStyle {
  TextStyle withColor(Color color) => copyWith(color: color);
}
