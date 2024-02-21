import 'package:flutter/material.dart';
import 'package:myoro_player/widgets/screens/home_screen.dart';

/// [AppBar] of [HomeScreen]
class HomeScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeScreenAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        title: const Row(
          children: [
            Text('Start'),
          ],
        ),
      );
}
