import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_bloc.dart';
import 'package:myoro_player/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_event.dart';
import 'package:myoro_player/shared/controllers/model_resolver_controller.dart';
import 'package:myoro_player/shared/helpers/context_menu_helper.dart';
import 'package:myoro_player/shared/models/context_menu_item.dart';
import 'package:myoro_player/shared/models/playlist.dart';
import 'package:myoro_player/shared/widgets/modals/delete_playlist_from_device_confirmation_modal.dart';
import 'package:myoro_player/shared/widgets/modals/rename_playlist_modal.dart';

enum MainScreenBodyPlaylistSideBarContextMenuEnum {
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

  const MainScreenBodyPlaylistSideBarContextMenuEnum(this.icon, this.text);

  void onTap(
    BuildContext context,
    Playlist playlist,
    ModelResolverController<List<Playlist>> playlistResolverController,
  ) {
    final mainScreenBodyPlaylistSideBarBloc = BlocProvider.of<MainScreenBodyPlaylistSideBarBloc>(context);

    switch (this) {
      case MainScreenBodyPlaylistSideBarContextMenuEnum.renamePlaylist:
        return RenamePlaylistModal.show(context, playlist, playlistResolverController);
      case MainScreenBodyPlaylistSideBarContextMenuEnum.setPlaylistImage:
        mainScreenBodyPlaylistSideBarBloc.add(SetPlaylistImageEvent(playlist));
        break;
      case MainScreenBodyPlaylistSideBarContextMenuEnum.removePlaylistImage:
        mainScreenBodyPlaylistSideBarBloc.add(SetPlaylistImageEvent(playlist, removeImage: true));
        break;
      case MainScreenBodyPlaylistSideBarContextMenuEnum.deletePlaylistFromMyoroPlayer:
        mainScreenBodyPlaylistSideBarBloc.add(RemovePlaylistFromMyoroPlayerEvent(playlist));
        break;
      case MainScreenBodyPlaylistSideBarContextMenuEnum.deletePlaylistFromComputer:
        DeletePlaylistFromDeviceConfirmationModal.show(context, playlist: playlist, playlistResolverController: playlistResolverController);
    }
  }

  static void showContextMenu(
    BuildContext context,
    TapDownDetails details,
    Playlist playlist,
    ModelResolverController<List<Playlist>> playlistResolverController,
  ) {
    final List<ContextMenuItem> items = [];

    for (final value in MainScreenBodyPlaylistSideBarContextMenuEnum.values) {
      if (value == MainScreenBodyPlaylistSideBarContextMenuEnum.removePlaylistImage && playlist.image == null) {
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
}
