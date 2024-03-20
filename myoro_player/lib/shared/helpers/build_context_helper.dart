import 'package:flutter/material.dart';

extension BuildContextHelper on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
}
