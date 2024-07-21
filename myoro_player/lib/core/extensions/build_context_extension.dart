import 'package:flutter/material.dart';
import 'package:myoro_player/core/helpers/snack_bar_helper.dart';

extension BuildContextExtenion on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  TextTheme get textTheme => Theme.of(this).textTheme;

  void showDialogSnackBar(String message) {
    SnackBarHelper.showDialogSnackBar(this, message);
  }

  void showErrorSnackBar(String message) {
    SnackBarHelper.showErrorSnackBar(this, message);
  }

  void closeSnackBar() {
    SnackBarHelper.closeSnackBar(this);
  }
}
