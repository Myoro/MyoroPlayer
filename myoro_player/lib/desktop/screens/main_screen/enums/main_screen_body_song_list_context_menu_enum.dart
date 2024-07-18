import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/shared/blocs/song_controls_bloc/song_controls_bloc.dart';
import 'package:myoro_player/shared/blocs/song_controls_bloc/song_controls_event.dart';
import 'package:myoro_player/shared/blocs/song_listing_bloc/song_listing_bloc.dart';
import 'package:myoro_player/shared/blocs/song_listing_bloc/song_listing_event.dart';
import 'package:myoro_player/shared/extensions/build_context_extension.dart';
import 'package:myoro_player/shared/helpers/context_menu_helper.dart';
import 'package:myoro_player/shared/models/context_menu_item.dart';
import 'package:myoro_player/shared/models/song.dart';
import 'package:myoro_player/shared/widgets/modals/delete_song_modal.dart';

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
    final mainScreenBodySongListBloc = BlocProvider.of<SongListingBloc>(context);
    final mainScreenBodyFooterBloc = BlocProvider.of<SongControlsBloc>(context);

    switch (this) {
      case MainScreenBodySongListContextMenuEnum.addToQueue:
        mainScreenBodyFooterBloc.add(AddToQueueEvent(song));
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
