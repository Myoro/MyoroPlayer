import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_bloc.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_event.dart';
import 'package:frontend/shared/controllers/song_controller.dart';
import 'package:frontend/shared/extensions/build_context_extension.dart';
import 'package:frontend/shared/helpers/context_menu_helper.dart';
import 'package:frontend/shared/models/context_menu_item.dart';
import 'package:frontend/shared/models/song.dart';
import 'package:frontend/shared/widgets/modals/delete_song_modal.dart';
import 'package:kiwi/kiwi.dart';

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
    final mainScreenBodySongListBloc = BlocProvider.of<MainScreenBodySongListBloc>(context);

    switch (this) {
      case MainScreenBodySongListContextMenuEnum.addToQueue:
        KiwiContainer().resolve<SongController>().addToQueue(song);
        context.showDialogSnackBar(context, '${song.title} added to queue.');
        break;
      case MainScreenBodySongListContextMenuEnum.copySongToPlaylist:
        mainScreenBodySongListBloc.add(CopySongToPlaylistEvent(song));
        break;
      case MainScreenBodySongListContextMenuEnum.moveSongToPlaylist:
        mainScreenBodySongListBloc.add(MoveSongToPlaylistEvent(song));
        break;
      case MainScreenBodySongListContextMenuEnum.deleteSong:
        DeleteSongModal.show(context, song);
        break;
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
