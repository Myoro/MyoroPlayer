import 'package:flutter/material.dart';
import 'package:myoro_player/widgets/desktop/home_screen/body/song_section/song_controls/additional_controls.dart';
import 'package:myoro_player/widgets/desktop/home_screen/body/song_section/song_controls/song_control_buttons_and_slider.dart';
import 'package:myoro_player/widgets/desktop/home_screen/body/song_section/song_controls/song_information.dart';

class SongControls extends StatelessWidget {
  const SongControls({super.key});

  @override
  Widget build(BuildContext context) =>
      LayoutBuilder(builder: (context, constraints) {
        if (constraints.maxWidth > 250) {
          return SizedBox(
            height: 95,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                if (constraints.maxWidth >= 565) ...[
                  const SizedBox(width: 5),
                  const SongInformation(),
                  const Spacer(),
                ],
                const SongControlButtonsAndSlider(),
                if (constraints.maxWidth >= 830) ...[
                  const Spacer(),
                  const AdditionalControls(),
                ],
              ],
            ),
          );
        } else {
          return const SizedBox.shrink();
        }
      });
}
