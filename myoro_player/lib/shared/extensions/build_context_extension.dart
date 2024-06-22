import 'package:flutter/material.dart';

extension BuildContextExtenion on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  TextTheme get textTheme => Theme.of(this).textTheme;
}
