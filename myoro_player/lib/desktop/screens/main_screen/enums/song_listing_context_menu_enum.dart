import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/core/helpers/platform_helper.dart';
import 'package:myoro_player/mobile/widgets/modals/base_dropdown_modal.dart';
import 'package:myoro_player/shared/blocs/song_controls_bloc/song_controls_bloc.dart';
import 'package:myoro_player/shared/blocs/song_controls_bloc/song_controls_event.dart';
import 'package:myoro_player/shared/blocs/song_listing_bloc/song_listing_bloc.dart';
import 'package:myoro_player/shared/blocs/song_listing_bloc/song_listing_event.dart';
import 'package:myoro_player/core/extensions/build_context_extension.dart';
import 'package:myoro_player/core/helpers/context_menu_helper.dart';
import 'package:myoro_player/core/models/menu_item.dart';
import 'package:myoro_player/core/models/song.dart';
import 'package:myoro_player/core/widgets/modals/delete_song_modal.dart';

enum SongListingContextMenuEnum {
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

  const SongListingContextMenuEnum(this.icon, this.text);

  void onTap(
    BuildContext context,
    Song song,
  ) {
    final mainScreenBodySongListBloc = BlocProvider.of<SongListingBloc>(context);
    final mainScreenBodyFooterBloc = BlocProvider.of<SongControlsBloc>(context);

    switch (this) {
      case SongListingContextMenuEnum.addToQueue:
        mainScreenBodyFooterBloc.add(AddToQueueEvent(song));
        context.showDialogSnackBar('${song.title} added to queue.');
        break;
      case SongListingContextMenuEnum.copySongToPlaylist:
        mainScreenBodySongListBloc.add(CopySongToPlaylistEvent(song));
        break;
      case SongListingContextMenuEnum.moveSongToPlaylist:
        mainScreenBodySongListBloc.add(MoveSongToPlaylistEvent(song));
        break;
      case SongListingContextMenuEnum.deleteSong:
        DeleteSongModal.show(context, song);
        break;
    }
  }

  static List<MenuItem> _buildMenuItems(
    BuildContext context,
    Song song,
  ) {
    return SongListingContextMenuEnum.values.map<MenuItem>(
      (value) {
        return MenuItem(
          icon: value.icon,
          text: value.text,
          onTap: () {
            value.onTap.call(context, song);

            if (KiwiContainer().resolve<PlatformHelper>().isMobile) {
              Navigator.of(context).pop();
            }
          },
        );
      },
    ).toList();
  }

  static void showContextMenu(
    BuildContext context,
    TapDownDetails details,
    Song song,
  ) {
    assert(
      KiwiContainer().resolve<PlatformHelper>().isDesktop,
      '[SongListingContextMenuEnum.showDropdownModal]: This method is only for desktop.',
    );

    ContextMenuHelper.show(
      context,
      details,
      width: 287,
      items: _buildMenuItems(
        context,
        song,
      ),
    );
  }

  static void showDropdownModal(
    BuildContext context,
    Song song,
  ) {
    assert(
      KiwiContainer().resolve<PlatformHelper>().isMobile,
      '[SongListingContextMenuEnum.showDropdownModal]: This method is only for mobile.',
    );

    BaseDropdownModal.show(
      context,
      _buildMenuItems(
        context,
        song,
      ),
    );
  }
}
