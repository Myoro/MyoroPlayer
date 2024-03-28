import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/shared/blocs/playlist_cubit.dart';
import 'package:myoro_player/shared/enums/playlist_actions_enum.dart';

class PlaylistActions extends Intent {
  final PlaylistActionsEnum playlistAction;

  const PlaylistActions(this.playlistAction);

  static void createNewPlaylist(BuildContext context) {
    BlocProvider.of<PlaylistCubit>(context).createNewPlaylist();
  }

  static void addPlaylist(BuildContext context) {
    BlocProvider.of<PlaylistCubit>(context).addPlaylist();
  }
}
