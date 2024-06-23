import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/shared/blocs/user_preferences_cubit.dart';

enum MainScreenAppBarDrawerItemsEnum {
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

  void callback(BuildContext context) {
    return switch (this) {
      MainScreenAppBarDrawerItemsEnum.loginSignup => print('Login/signup'),
      MainScreenAppBarDrawerItemsEnum.toggleTheme => BlocProvider.of<UserPreferencesCubit>(context).toggleTheme(),
      MainScreenAppBarDrawerItemsEnum.quit => exit(0),
    };
  }
}
