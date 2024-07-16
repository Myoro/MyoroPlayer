import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_bloc.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_event.dart';
import 'package:myoro_player/shared/blocs/user_preferences_cubit.dart';
import 'package:myoro_player/shared/helpers/device_helper.dart';
import 'package:kiwi/kiwi.dart';

enum MainScreenAppBarDrawerItemsEnum {
  openPlaylist(
    Icons.folder_open,
    'Open playlist(s)',
  ),
  createPlaylist(
    Icons.create_new_folder,
    'Create a new playlist',
  ),
  toggleTheme(
    Icons.sunny,
    'Toggle theme',
  ),
  quit(
    Icons.close,
    'Quit MyoroPlayer',
  );

  final IconData icon;
  final String text;

  const MainScreenAppBarDrawerItemsEnum(this.icon, this.text);

  void callback(BuildContext context) {
    final mainScreenBodyPlaylistSideBarBloc = BlocProvider.of<MainScreenBodyPlaylistSideBarBloc>(
      context,
    );

    return switch (this) {
      MainScreenAppBarDrawerItemsEnum.openPlaylist => mainScreenBodyPlaylistSideBarBloc.add(const OpenPlaylistEvent()),
      MainScreenAppBarDrawerItemsEnum.createPlaylist => mainScreenBodyPlaylistSideBarBloc.add(const CreatePlaylistEvent()),
      MainScreenAppBarDrawerItemsEnum.toggleTheme => BlocProvider.of<UserPreferencesCubit>(context).toggleTheme(),
      MainScreenAppBarDrawerItemsEnum.quit => KiwiContainer().resolve<DeviceHelper>().quit(),
    };
  }
}
