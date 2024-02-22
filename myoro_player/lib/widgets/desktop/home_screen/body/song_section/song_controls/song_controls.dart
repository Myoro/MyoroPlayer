import 'package:flutter/material.dart';
import 'package:myoro_player/widgets/desktop/home_screen/body/song_section/song_controls/song_control_buttons_and_slider.dart';
import 'package:myoro_player/widgets/desktop/home_screen/body/song_section/song_controls/song_information.dart';

class SongControls extends StatelessWidget {
  const SongControls({super.key});

  @override
  Widget build(BuildContext context) => const SizedBox(
        height: 80,
        child: Row(
          children: [
            SongInformation(),
            Spacer(),
            SongControlButtonsAndSlider(),
            Spacer(),
          ],
        ),
      );
}
