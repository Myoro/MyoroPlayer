import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/blocs/playlist_cubit.dart';

class NewPlaylistAction extends Intent {
  const NewPlaylistAction();

  // TODO
  static void newPlaylist(BuildContext context) {
    BlocProvider.of<PlaylistCubit>(context).addPlaylist();
  }
}
