import 'package:flutter/material.dart';
import 'package:frontend/shared/helpers/context_menu_helper.dart';
import 'package:frontend/shared/models/context_menu_item.dart';
import 'package:frontend/shared/models/song.dart';

enum MainScreenBodySongListContextMenuEnum {
  addToQueue(
    Icons.add_to_queue,
    'Add to queue',
  ),
  copySongToPlaylist(
    Icons.copy,
    'Copy song to another playlist',
  ),
  moveSongToPlaylist(
    Icons.move_down,
    'Move song to another playlist',
  ),
  deleteSong(
    Icons.delete,
    'Delete song from device',
  );

  final IconData icon;
  final String text;

  const MainScreenBodySongListContextMenuEnum(this.icon, this.text);

  void onTap(
    BuildContext context,
    Song song,
  ) {
    switch (this) {
      case MainScreenBodySongListContextMenuEnum.addToQueue:
        throw UnimplementedError();
      case MainScreenBodySongListContextMenuEnum.copySongToPlaylist:
        throw UnimplementedError();
      case MainScreenBodySongListContextMenuEnum.moveSongToPlaylist:
        throw UnimplementedError();
      case MainScreenBodySongListContextMenuEnum.deleteSong:
        throw UnimplementedError();
    }
  }

  static void showContextMenu(
    BuildContext context,
    TapDownDetails details,
    Song song,
  ) {
    ContextMenuHelper.show(
      context,
      details,
      width: 287,
      items: MainScreenBodySongListContextMenuEnum.values.map(
        (value) {
          return ContextMenuItem(
            icon: value.icon,
            text: value.text,
            onTap: () => value.onTap.call(context, song),
          );
        },
      ).toList(),
    );
  }
}
