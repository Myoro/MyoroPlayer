import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/inputs/outline_input.dart';
import 'package:frontend/shared/widgets/modals/base_modal.dart';

/// Modal used for input forms
final class RenamePlaylistModal extends StatefulWidget {
  final TextEditingController nameController;

  const RenamePlaylistModal._(this.nameController);

  static void show(BuildContext context) {
    final nameController = TextEditingController();

    BaseModal.show(
      context,
      title: 'Rename playlist',
      child: RenamePlaylistModal._(
        nameController,
      ),
    );
  }

  @override
  State<RenamePlaylistModal> createState() => _RenamePlaylistModalState();
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
        ),
      ],
    );
  }
}
