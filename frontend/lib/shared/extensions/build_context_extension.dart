import 'package:flutter/material.dart';
import 'package:frontend/shared/helpers/snack_bar_helper.dart';

extension BuildContextExtenion on BuildContext {
  bool get isDarkMode => Theme.of(this).brightness == Brightness.dark;
  TextTheme get textTheme => Theme.of(this).textTheme;

  void showDialogSnackBar(BuildContext context, String message) {
    SnackBarHelper.showDialogSnackBar(context, message);
  }

  void showErrorSnackBar(BuildContext context, String message) {
    SnackBarHelper.showErrorSnackBar(context, message);
  }

  void closeSnackBar(BuildContext context) {
    SnackBarHelper.closeSnackBar(context);
  }
}
