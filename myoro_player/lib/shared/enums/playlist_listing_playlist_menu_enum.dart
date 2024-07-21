import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/shared/blocs/playlist_listing_bloc/playlist_listing_bloc.dart';
import 'package:myoro_player/shared/blocs/playlist_listing_bloc/playlist_listing_event.dart';
import 'package:myoro_player/core/controllers/model_resolver_controller.dart';
import 'package:myoro_player/core/helpers/context_menu_helper.dart';
import 'package:myoro_player/core/helpers/platform_helper.dart';
import 'package:myoro_player/core/models/context_menu_item.dart';
import 'package:myoro_player/core/models/playlist.dart';
import 'package:myoro_player/core/widgets/modals/delete_playlist_from_device_confirmation_modal.dart';
import 'package:myoro_player/core/widgets/modals/rename_playlist_modal.dart';
import 'package:myoro_player/shared/widgets/screens/main_screen/playlist_listing.dart';

/// Enum for displaying the menu for a [Playlist] within [PlaylistListing]
///
/// On desktop, use
enum PlaylistListingPlaylistMenuEnum {
  renamePlaylist(
    Icons.change_circle,
    'Rename playlist',
  ),
  setPlaylistImage(
    Icons.image,
    'Set playlist\'s image on MyoroPlayer',
  ),
  removePlaylistImage(
    Icons.remove,
    'Remove playlist\'s image on MyoroPlayer',
  ),
  deletePlaylistFromMyoroPlayer(
    Icons.playlist_remove,
    'Remove playlist from MyoroPlayer',
  ),
  deletePlaylistFromComputer(
    Icons.delete_forever,
    'Delete playlist from computer',
  );

  final IconData icon;
  final String text;

  const PlaylistListingPlaylistMenuEnum(this.icon, this.text);

  void onTap(
    BuildContext context,
    Playlist playlist,
    ModelResolverController<List<Playlist>> playlistResolverController,
  ) {
    final mainScreenBodyPlaylistSideBarBloc = BlocProvider.of<PlaylistListingBloc>(context);

    return switch (this) {
      PlaylistListingPlaylistMenuEnum.renamePlaylist => RenamePlaylistModal.show(context, playlist, playlistResolverController),
      PlaylistListingPlaylistMenuEnum.setPlaylistImage => mainScreenBodyPlaylistSideBarBloc.add(SetPlaylistImageEvent(playlist)),
      PlaylistListingPlaylistMenuEnum.removePlaylistImage => mainScreenBodyPlaylistSideBarBloc.add(SetPlaylistImageEvent(playlist, removeImage: true)),
      PlaylistListingPlaylistMenuEnum.deletePlaylistFromMyoroPlayer => mainScreenBodyPlaylistSideBarBloc.add(RemovePlaylistFromMyoroPlayerEvent(playlist)),
      PlaylistListingPlaylistMenuEnum.deletePlaylistFromComputer =>
        DeletePlaylistFromDeviceConfirmationModal.show(context, playlist: playlist, playlistResolverController: playlistResolverController),
    };
  }

  static void showContextMenu(
    BuildContext context,
    TapDownDetails details,
    Playlist playlist,
    ModelResolverController<List<Playlist>> playlistResolverController,
  ) {
    assert(
      PlatformHelper.isDesktop,
      '[PlaylistListingPlaylistMenu.showContextMenu]: This method is only for desktop.',
    );

    final List<ContextMenuItem> items = [];

    for (final value in PlaylistListingPlaylistMenuEnum.values) {
      if (value == PlaylistListingPlaylistMenuEnum.removePlaylistImage && playlist.image == null) {
        continue;
      } else {
        items.add(
          ContextMenuItem(
            icon: value.icon,
            text: value.text,
            onTap: () => value.onTap.call(
              context,
              playlist,
              playlistResolverController,
            ),
          ),
        );
      }
    }

    ContextMenuHelper.show(
      context,
      details,
      width: 366,
      items: items,
    );
  }

  // TODO
  static void showDropdownModal(
    BuildContext context,
    Playlist playlist,
    ModelResolverController playlistResolverController,
  ) {
    print('Start');
  }
}
