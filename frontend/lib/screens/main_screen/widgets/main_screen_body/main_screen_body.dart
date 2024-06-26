import 'package:flutter/material.dart';
import 'package:frontend/screens/main_screen/widgets/main_screen_body/main_screen_body_footer.dart';
import 'package:frontend/screens/main_screen/widgets/main_screen_body/main_screen_body_playlist_side_bar.dart';
import 'package:frontend/screens/main_screen/widgets/main_screen_body/main_screen_body_song_list.dart';
import 'package:frontend/shared/widgets/dividers/basic_divider.dart';

final class MainScreenBody extends StatelessWidget {
  const MainScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return const Row(
      children: [
        MainScreenBodyPlaylistSideBar(),
        Expanded(
          child: Column(
            children: [
              MainScreenBodySongList(),
              BasicDivider(
                direction: Axis.horizontal,
                padding: EdgeInsets.symmetric(
                  horizontal: 10,
                ),
              ),
              MainScreenBodyFooter(),
            ],
          ),
        ),
      ],
    );
  }
}
