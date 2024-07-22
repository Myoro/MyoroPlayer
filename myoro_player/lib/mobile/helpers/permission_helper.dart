import 'package:permission_handler/permission_handler.dart';

/// Used for requesting mobile permissoes such as file read/write permissions
final class PermissionHelper {
  static Future<void> requestPermissions() async {
    if (await Permission.storage.request().isGranted) {
      // Either the permission was already granted before or the user just granted it.
    } else {
      openAppSettings();
      print('What');
    }
  }

  static Future<bool> get storagePermissionsGranted async {
    return await Permission.storage.request().isGranted;
  }
}
