// coverage:ignore-file

import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';

/// Used for any operation regarding the file system
///
/// i.e. File/folder dialog menus, writing files, etc...
class FileSystemHelper {
  /// Returns the path to the folder in which the user wants to create, null if cancelled
  Future<String?> createFolderDialogWindow() async {
    return await FilePicker.platform.saveFile(
      dialogTitle: 'Choose the location of your new playlist',
    );
  }

  /// Returns the path to the folder in which the user wants to add, null if cancelled
  Future<String?> openFolderDialogWindow() async {
    return await FilePicker.platform.getDirectoryPath(
      dialogTitle: 'Choose the playlists you\'d like to add.',
    );
  }

  /// Creates a folder on the device. Returns if the operation was successful or not
  bool createFolder(String path) {
    try {
      Directory(path).createSync();

      return true;
    } catch (error) {
      if (kDebugMode) {
        print('[FileSystemHelper.createFolder]: Error creating folder: "$error".');
      }

      return false;
    }
  }
}
