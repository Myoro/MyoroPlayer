import 'package:flutter/material.dart';

extension BuildContextExtension on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
