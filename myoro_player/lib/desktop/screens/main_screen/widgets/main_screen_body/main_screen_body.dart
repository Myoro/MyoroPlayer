import 'package:flutter/material.dart';
import 'package:myoro_player/desktop/screens/main_screen/widgets/main_screen_body/main_screen_body_footer.dart';
import 'package:myoro_player/desktop/screens/main_screen/widgets/main_screen_body/main_screen_body_playlist_side_bar.dart';
import 'package:myoro_player/shared/screens/main_screen/song_listing.dart';
import 'package:myoro_player/core/widgets/dividers/basic_divider.dart';

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
              Expanded(child: SongListing()),
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
