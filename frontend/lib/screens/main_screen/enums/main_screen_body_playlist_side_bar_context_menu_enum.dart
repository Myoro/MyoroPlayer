import 'package:flutter/material.dart';
import 'package:frontend/shared/helpers/context_menu_helper.dart';
import 'package:frontend/shared/models/context_menu_item.dart';

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

  // coverage:ignore-start
  void onTap() {
    return switch (this) {
      MainScreenBodyPlaylistSideBarContextMenuEnum.renamePlaylist => print('Rename playlist'),
      MainScreenBodyPlaylistSideBarContextMenuEnum.setPlaylistImage => print('Set image'),
      MainScreenBodyPlaylistSideBarContextMenuEnum.deletePlaylistFromMyoroPlayer => print('Delete MP'),
      MainScreenBodyPlaylistSideBarContextMenuEnum.deletePlaylistFromComputer => print('Delete computer'),
    };
  }
  // coverage:ignore-end

  static void showContextMenu(BuildContext context, TapDownDetails details) {
    ContextMenuHelper.show(
      context,
      details,
      width: 330,
      items: MainScreenBodyPlaylistSideBarContextMenuEnum.values.map(
        (value) {
          return ContextMenuItem(
            icon: value.icon,
            text: value.text,
            onTap: value.onTap,
          );
        },
      ).toList(),
    );
  }
}
