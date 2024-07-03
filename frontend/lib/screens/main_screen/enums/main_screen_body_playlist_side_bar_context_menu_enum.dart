import 'package:flutter/material.dart';
import 'package:frontend/shared/controllers/model_resolver_controller.dart';
import 'package:frontend/shared/helpers/context_menu_helper.dart';
import 'package:frontend/shared/models/context_menu_item.dart';
import 'package:frontend/shared/models/playlist.dart';
import 'package:frontend/shared/widgets/modals/rename_playlist_modal.dart';

enum MainScreenBodyPlaylistSideBarContextMenuEnum {
  renamePlaylist(
    Icons.change_circle,
    'Rename playlist',
  ),
  setPlaylistImage(
    Icons.image,
    'Set playlist\'s image on MyoroPlayer',
  ),
  deletePlaylistFromMyoroPlayer(
    Icons.remove,
    'Remove playlist from MyoroPlayer',
  ),
  deletePlaylistFromComputer(
    Icons.delete_forever,
    'Delete playlist from computer',
  );

  final IconData icon;
  final String text;

  const MainScreenBodyPlaylistSideBarContextMenuEnum(this.icon, this.text);

  void onTap(
    BuildContext context,
    Playlist playlist,
    ModelResolverController<List<Playlist>> playlistResolverController,
  ) {
    switch (this) {
      case MainScreenBodyPlaylistSideBarContextMenuEnum.renamePlaylist:
        RenamePlaylistModal.show(context, playlist, playlistResolverController);
        break;
      case MainScreenBodyPlaylistSideBarContextMenuEnum.setPlaylistImage: // TODO
        throw UnimplementedError();
      case MainScreenBodyPlaylistSideBarContextMenuEnum.deletePlaylistFromMyoroPlayer: // TODO
        throw UnimplementedError();
      case MainScreenBodyPlaylistSideBarContextMenuEnum.deletePlaylistFromComputer: // TODO
        throw UnimplementedError();
    }
  }

  static void showContextMenu(
    BuildContext context,
    TapDownDetails details,
    Playlist playlist,
    ModelResolverController<List<Playlist>> playlistResolverController,
  ) {
    ContextMenuHelper.show(
      context,
      details,
      width: 330,
      items: MainScreenBodyPlaylistSideBarContextMenuEnum.values.map(
        (value) {
          return ContextMenuItem(
            icon: value.icon,
            text: value.text,
            onTap: (context) => value.onTap.call(
              context,
              playlist,
              playlistResolverController,
            ),
          );
        },
      ).toList(),
    );
  }
}
