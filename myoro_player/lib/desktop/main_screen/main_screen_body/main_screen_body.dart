import 'package:flutter/material.dart';
import 'package:myoro_player/desktop/main_screen/main_screen_body/playlist_side_bar.dart';
import 'package:myoro_player/desktop/main_screen/main_screen_body/song_list.dart';
import 'package:myoro_player/shared/widgets/bodies/base_body.dart';

class MainScreenBody extends StatelessWidget {
  const MainScreenBody({super.key});

  @override
  Widget build(BuildContext context) => const BaseBody(
        child: Row(
          children: [
            PlaylistSideBar(),
            SongList(),
          ],
        ),
      );
}
