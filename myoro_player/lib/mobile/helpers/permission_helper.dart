// coverage:ignore-file

import 'package:permission_handler/permission_handler.dart';

/// Used for requesting mobile permissoes such as file read/write permissions
final class PermissionHelper {
  static Future<bool> get permissionsGranted async {
    return await Permission.audio.isGranted;
  }
}
