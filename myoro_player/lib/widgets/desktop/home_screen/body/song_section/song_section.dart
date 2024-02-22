import 'package:flutter/material.dart';
import 'package:myoro_player/widgets/desktop/home_screen/body/song_section/song_controls/song_controls.dart';
import 'package:myoro_player/widgets/desktop/home_screen/body/song_section/song_list/song_list.dart';

class SongSection extends StatelessWidget {
  const SongSection({super.key});

  @override
  Widget build(BuildContext context) => const Expanded(
        child: Column(
          children: [
            SongList(),
            SongControls(),
          ],
        ),
      );
}
