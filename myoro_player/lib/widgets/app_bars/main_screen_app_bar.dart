import 'package:flutter/material.dart';
import 'package:myoro_player/widgets/app_bars/base_app_bar.dart';

class MainScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainScreenAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => const BaseAppBar(
        children: [
          Text('Start'),
        ],
      );
}
