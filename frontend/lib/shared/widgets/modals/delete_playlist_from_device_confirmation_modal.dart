import 'package:flutter/material.dart';
import 'package:frontend/shared/controllers/model_resolver_controller.dart';
import 'package:frontend/shared/helpers/file_system_helper.dart';
import 'package:frontend/shared/helpers/snack_bar_helper.dart';
import 'package:frontend/shared/models/playlist.dart';
import 'package:frontend/shared/services/playlist_service/playlist_service.dart';
import 'package:frontend/shared/widgets/modals/base_modal.dart';
import 'package:kiwi/kiwi.dart';

final class DeletePlaylistFromDeviceConfirmationModal extends StatelessWidget {
  final Playlist playlist;

  const DeletePlaylistFromDeviceConfirmationModal._(this.playlist);

  static void show(
    BuildContext context, {
    required Playlist playlist,
    required ModelResolverController<List<Playlist>> playlistResolverController,
  }) {
    BaseModal.show<dynamic>(
      context,
      requestCallback: () async {
        final kiwiContainer = KiwiContainer();
        if (!kiwiContainer.resolve<FileSystemHelper>().deleteFolder(playlist.path)) return;
        await kiwiContainer.resolve<PlaylistService>().delete(id: playlist.id!);
      },
      onSuccessCallback: (_) {
        playlistResolverController.refresh();
        SnackBarHelper.showDialogSnackBar(
          context,
          '${playlist.name} deleted from device successfully!',
        );
      },
      onErrorCallback: (String error) {
        SnackBarHelper.showErrorSnackBar(
          context,
          'Error deleting ${playlist.name}.',
        );
      },
      title: 'Delete ${playlist.name} from device',
      child: DeletePlaylistFromDeviceConfirmationModal._(playlist),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      'Are you sure you want to delete ${playlist.name}? This is not reversible!',
      style: Theme.of(context).textTheme.bodyMedium,
    );
  }
}
