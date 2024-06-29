import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_bloc.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_event.dart';
import 'package:frontend/shared/blocs/user_preferences_cubit.dart';

enum MainScreenAppBarDrawerItemsEnum {
  openPlaylists(
    Icons.folder_open,
    'Open playlist(s)',
  ),
  createPlaylist(
    Icons.create_new_folder,
    'Create a new playlist',
  ),
  loginSignup(
    Icons.login,
    'Login/signup',
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

  // coverage:ignore-start
  void callback(BuildContext context) {
    return switch (this) {
      MainScreenAppBarDrawerItemsEnum.openPlaylists => print('Open playlist(s)'),
      MainScreenAppBarDrawerItemsEnum.createPlaylist =>
        BlocProvider.of<MainScreenBodyPlaylistSideBarBloc>(context)
            .add(const CreatePlaylistEvent()),
      MainScreenAppBarDrawerItemsEnum.loginSignup => print('Login/signup'),
      MainScreenAppBarDrawerItemsEnum.toggleTheme =>
        BlocProvider.of<UserPreferencesCubit>(context).toggleTheme(),
      MainScreenAppBarDrawerItemsEnum.quit => exit(0),
    };
  }
  // coverage:ignore-end
}
