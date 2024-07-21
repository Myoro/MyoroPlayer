import 'package:faker/faker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/core/controllers/base_drawer_controller.dart';
import 'package:myoro_player/core/models/menu_item.dart';
import 'package:myoro_player/core/models/playlist.dart';
import 'package:myoro_player/mobile/screens/main_screen/widgets/main_screen_app_bar/main_screen_app_bar_playlist_drawer.dart';
import 'package:myoro_player/mobile/widgets/modals/base_dropdown_modal.dart';

/// Dropdown modal for a [Playlist]'s options in [MainScreenAppBarPlaylistDrawer]
final class MainScreenAppBarPlaylistDropdownModal {
  static void show(BuildContext context) {
    context.read<BaseDrawerController>().closeDrawer();

    BaseDropdownModal.show(
      context,
      List.generate(
        10,
        (_) => MenuItem(
          icon: [Icons.abc, Icons.ac_unit, Icons.zoom_out_sharp][faker.randomGenerator.integer(3)],
          text: faker.randomGenerator.string(20),
          onTap: () {
            if (kDebugMode) {
              print('Hey');
            }
          },
        ),
      ),
    );
  }
}
