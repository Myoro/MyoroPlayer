import 'package:flutter/material.dart';
import 'package:myoro_player/desktop/main_screen/widgets/main_screen_body/widgets/playlist_side_bar.dart';
import 'package:myoro_player/desktop/main_screen/widgets/main_screen_body/widgets/song_list.dart';
import 'package:myoro_player/shared/widgets/base_body.dart';

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
