import 'package:flutter/material.dart';
import 'package:myoro_player/mobile/widgets/snack_bars/base_snack_bar.dart' as mobile;
import 'package:myoro_player/core/enums/snack_bar_type_enum.dart';
import 'package:myoro_player/desktop/widgets/snack_bars/base_snack_bar.dart' as desktop;
import 'package:myoro_player/core/helpers/platform_helper.dart';

/// For displaying/controlling snack bar messages
final class SnackBarHelper {
  static void _showSnackBar(BuildContext context, SnackBarTypeEnum snackBarType, String message) {
    closeSnackBar(context);
    ScaffoldMessenger.of(context).showSnackBar(
      PlatformHelper.isDesktop
          ? desktop.BaseSnackBar(
              context,
              snackBarType: snackBarType,
              message: message,
            )
          : mobile.BaseSnackBar(
              context,
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
