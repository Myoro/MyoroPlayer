import 'package:flutter/material.dart';
import 'package:myoro_player/shared/enums/snack_bar_type_enum.dart';
import 'package:myoro_player/shared/widgets/snack_bars/base_snack_bar.dart';

/// For displaying/controlling snack bar messages
final class SnackBarHelper {
  void _showSnackBar(BuildContext context, SnackBarTypeEnum snackBarType, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      BaseSnackBar(
        snackBarType: SnackBarTypeEnum.error,
        message: message,
      ),
    );
  }

  void showDialogSnackBar(BuildContext context, String message) {
    _showSnackBar(
      context,
      SnackBarTypeEnum.dialog,
      message,
    );
  }

  void showErrorSnackBar(BuildContext context, String message) {
    _showSnackBar(
      context,
      SnackBarTypeEnum.error,
      message,
    );
  }

  void closeSnackBar(BuildContext context) {
    ScaffoldMessenger.of(context).hideCurrentSnackBar();
  }
}
