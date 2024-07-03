import 'package:flutter/material.dart';
import 'package:frontend/shared/enums/snack_bar_type_enum.dart';
import 'package:frontend/shared/widgets/snack_bars/base_snack_bar.dart';

/// For displaying/controlling snack bar messages
final class SnackBarHelper {
  static void _showSnackBar(BuildContext context, SnackBarTypeEnum snackBarType, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      BaseSnackBar(
        snackBarType: snackBarType,
        message: message,
      ),
    );
  }

  static void showDialogSnackBar(BuildContext context, String message) {
    _showSnackBar(
      context,
      SnackBarTypeEnum.dialog,
      message,
    );
  }

  static void showErrorSnackBar(BuildContext context, String message) {
    _showSnackBar(
      context,
      SnackBarTypeEnum.error,
      message,
    );
  }

  static void closeSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
