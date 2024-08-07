import 'dart:io';

import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/core/helpers/platform_helper.dart';

extension StringExtension on String {
  /// Grabs the name of a file/folder in a path
  String get pathName => split(KiwiContainer().resolve<PlatformHelper>().slash).last;

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
  bool get folderExists => Directory(this).existsSync();
}
