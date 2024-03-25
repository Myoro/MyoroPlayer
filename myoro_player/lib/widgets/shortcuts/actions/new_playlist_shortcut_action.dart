import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';

class NewPlaylistAction extends Intent {
  const NewPlaylistAction();

  // TODO
  static void newPlaylist() async {
    String? folder = await FilePicker.platform.saveFile(
      dialogTitle: 'Create New Playlist',
    );

    if (folder == null) return;

    // TODO: Finish implementation
  }
}
