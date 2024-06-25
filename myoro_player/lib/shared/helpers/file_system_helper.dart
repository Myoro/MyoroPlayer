import 'package:file_picker/file_picker.dart';

/// Used for any operation regarding the file system
///
/// i.e. File/folder dialog menus, writing files, etc...
final class FileSystemHelper {
  /// Returns the path to the folder in which the user wants to create, null if cancelled
  Future<String?> createDirectoryDialogWindow() async {
    return await FilePicker.platform.saveFile(
      dialogTitle: 'Choose the location of your new playlist',
    );
  }
}
