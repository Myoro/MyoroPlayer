import 'package:flutter/material.dart';
import 'package:frontend/shared/controllers/base_drawer_controller.dart';
import 'package:provider/provider.dart';

final class MainScreenAppBarDrawer extends StatelessWidget {
  const MainScreenAppBarDrawer({super.key});

  static void show(BuildContext context) {
    context.read<BaseDrawerController>().openDrawer(
          drawerContent: const MainScreenAppBarDrawer(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return const Text('Star bing bingt');
  }
}
