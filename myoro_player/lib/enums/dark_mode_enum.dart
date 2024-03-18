import 'package:flutter/material.dart';

enum DarkModeEnum {
  light(0, ThemeMode.light),
  dark(1, ThemeMode.dark),
  system(2, ThemeMode.system);

  final int databaseId;
  final ThemeMode themeMode;

  const DarkModeEnum(this.databaseId, this.themeMode);
}
