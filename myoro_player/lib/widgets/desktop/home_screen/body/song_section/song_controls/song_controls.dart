import 'package:flutter/material.dart';
import 'package:myoro_player/widgets/desktop/home_screen/body/song_section/song_controls/additional_controls/additional_controls.dart';
import 'package:myoro_player/widgets/desktop/home_screen/body/song_section/song_controls/song_control_buttons_and_slider/song_control_buttons_and_slider.dart';
import 'package:myoro_player/widgets/desktop/home_screen/body/song_section/song_controls/song_information/song_information.dart';

class SongControls extends StatelessWidget {
  const SongControls({super.key});

  @override
  Widget build(BuildContext context) {
    final double screenWidth = MediaQuery.of(context).size.width;

    return SizedBox(
      height: 95,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          if (screenWidth >= 765) ...[
            const SizedBox(width: 5),
            const SongInformation(),
            const Spacer(),
          ],
          const SongControlButtonsAndSlider(),
          if (screenWidth >= 1030) ...[
            const Spacer(),
            const AdditionalControls(),
          ],
        ],
      ),
    );
  }
}
