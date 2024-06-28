import 'dart:io';

import 'package:myoro_player/shared/helpers/platform_helper.dart';

extension StringExtension on String {
  /// Grabs the name of a file/folder in a path
  String getNameFromPath({bool removeFileExtension = false}) =>
      split(PlatformHelper.isWindows ? '\\' : '/').last;

  /// Checks if the [String] (specifically from getNameFromPath) is a valid folder name
  bool get isValidFolderName {
    final List<String> invalidCharacters = ['/', '\\', ':', '*', '?', '"', '<', '>', '|'];

    for (final character in invalidCharacters) {
      if (contains(character)) {
        return false;
      }
    }

    return true;
  }

  /// Checks if the [String] exists on the device
  bool get pathExists => File(this).existsSync();
}
