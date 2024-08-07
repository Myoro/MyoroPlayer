import 'package:flutter/material.dart';
import 'package:myoro_player/core/controllers/model_resolver_controller.dart';
import 'package:myoro_player/core/extensions/build_context_extension.dart';
import 'package:myoro_player/core/helpers/file_system_helper.dart';
import 'package:myoro_player/core/models/playlist.dart';
import 'package:myoro_player/core/services/playlist_service/playlist_service.dart';
import 'package:myoro_player/core/widgets/modals/base_modal.dart';
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
        context.showDialogSnackBar('${playlist.name} deleted from device successfully!');
      },
      onErrorCallback: (String error) {
        context.showErrorSnackBar('Error deleting ${playlist.name}.');
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
