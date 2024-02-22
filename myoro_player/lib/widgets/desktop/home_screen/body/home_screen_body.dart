import 'package:flutter/material.dart';
import 'package:myoro_player/widgets/desktop/home_screen/body/side_bar/side_bar.dart';
import 'package:myoro_player/widgets/desktop/home_screen/body/song_section/song_section.dart';

class HomeScreenBody extends StatelessWidget {
  const HomeScreenBody({super.key});

  @override
  Widget build(BuildContext context) => const Row(
        children: [
          SideBar(),
          SizedBox(width: 10),
          SongSection(),
        ],
      );
}
