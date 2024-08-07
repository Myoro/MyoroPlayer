import 'package:flutter/material.dart';
import 'package:myoro_player/core/controllers/model_resolver_controller.dart';
import 'package:myoro_player/core/extensions/build_context_extension.dart';
import 'package:myoro_player/core/extensions/string_extension.dart';
import 'package:myoro_player/core/models/playlist.dart';
import 'package:myoro_player/core/services/playlist_service/playlist_service.dart';
import 'package:myoro_player/core/widgets/inputs/outline_input.dart';
import 'package:myoro_player/core/widgets/modals/base_modal.dart';
import 'package:kiwi/kiwi.dart';

/// Modal used for input forms
final class RenamePlaylistModal extends StatefulWidget {
  final TextEditingController nameController;

  const RenamePlaylistModal._(this.nameController);

  static void show(
    BuildContext context,
    Playlist playlist,
    ModelResolverController<List<Playlist>> playlistResolverController,
  ) {
    final nameController = TextEditingController();

    BaseModal.show<Playlist?>(
      context,
      validationCallback: () => nameControllerValidation(nameController),
      requestCallback: () async => await KiwiContainer().resolve<PlaylistService>().renamePlaylist(
            playlist: playlist,
            newName: nameController.text,
          ),
      onSuccessCallback: (Playlist? model) {
        playlistResolverController.refresh();

        context.showDialogSnackBar('Playlist renamed successfully!');
      },
      title: 'Rename playlist',
      child: RenamePlaylistModal._(
        nameController,
      ),
    );
  }

  @override
  State<RenamePlaylistModal> createState() => _RenamePlaylistModalState();

  static String? nameControllerValidation(TextEditingController nameController) {
    if (nameController.text.isEmpty) {
      return 'Name cannot be empty';
    } else if (!nameController.text.isValidFolderName) {
      return 'Cannot contains the characters: /\\:*?"<>|';
    }

    return null;
  }
}

class _RenamePlaylistModalState extends State<RenamePlaylistModal> {
  TextEditingController get _nameController => widget.nameController;
  final _nameFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    _nameFocusNode.requestFocus();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _nameFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        OutlineInput(
          controller: _nameController,
          focusNode: _nameFocusNode,
          validationCallback: (text) => RenamePlaylistModal.nameControllerValidation(_nameController),
        ),
      ],
    );
  }
}
