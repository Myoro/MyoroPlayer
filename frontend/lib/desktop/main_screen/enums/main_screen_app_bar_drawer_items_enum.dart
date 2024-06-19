import 'package:flutter/material.dart';
import 'package:frontend/desktop/main_screen/widgets/main_screen_app_bar/main_screen_app_bar_drawer.dart';
import 'package:frontend/shared/controllers/base_drawer_controller.dart';
import 'package:provider/provider.dart';

/// Drawer items for [MainScreenAppBarDrawer]
enum MainScreenAppBarDrawerItemsEnum {
  toggleTheme(
    Icons.sunny,
    'Toggle MyoroPlayer\'s theme',
  ),
  quit(
    Icons.exit_to_app,
    'Quit MyoroPlayer',
  );

  final IconData icon;
  final String text;

  const MainScreenAppBarDrawerItemsEnum(this.icon, this.text);

  callback(BuildContext context) {
    switch (this) {
      case MainScreenAppBarDrawerItemsEnum.toggleTheme:
        print('Toggle theme');
        break;
      case MainScreenAppBarDrawerItemsEnum.quit:
        print('Quit MyoroPlayer');
        break;
    }

    context.read<BaseDrawerController>().closeDrawer();
  }
}
