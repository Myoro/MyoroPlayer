import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/shared/controllers/base_drawer_controller.dart';
import 'package:myoro_player/shared/widgets/drawers/base_drawer.dart';
import 'package:myoro_player/shared/widgets/screens/main_screen/playlist_listing.dart';

final class MainScreenAppBarPlaylistDrawer {
  static void show(BuildContext context) {
    context.read<BaseDrawerController>().openDrawer(
          drawer: const BaseDrawer(
            isEndDrawer: false,
            title: 'Playlists',
            child: PlaylistListing(),
          ),
        );
  }
}
