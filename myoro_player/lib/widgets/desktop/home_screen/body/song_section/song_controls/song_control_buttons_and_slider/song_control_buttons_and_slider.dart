import 'package:flutter/material.dart';
import 'package:myoro_player/widgets/shared/buttons/base_hover_button.dart';
import 'package:myoro_player/widgets/shared/sliders/base_slider.dart';

class SongControlButtonsAndSlider extends StatelessWidget {
  const SongControlButtonsAndSlider({super.key});

  @override
  Widget build(BuildContext context) => Column(
        children: [
          const BaseSlider(width: 250),
          Row(
            children: [
              const SizedBox(width: 5),
              BaseHoverButton(
                onTap: () {}, // TODO
                icon: Icons.shuffle,
                iconSize: 40,
                padding: EdgeInsets.zero,
              ),
              const SizedBox(width: 5),
              BaseHoverButton(
                onTap: () {}, // TODO
                icon: Icons.skip_previous,
                iconSize: 40,
                padding: EdgeInsets.zero,
              ),
              const SizedBox(width: 5),
              BaseHoverButton(
                onTap: () {}, // TODO
                icon: Icons.play_arrow,
                iconSize: 40,
                padding: EdgeInsets.zero,
              ),
              const SizedBox(width: 5),
              BaseHoverButton(
                onTap: () {}, // TODO
                icon: Icons.skip_next,
                iconSize: 40,
                padding: EdgeInsets.zero,
              ),
              BaseHoverButton(
                onTap: () {}, // TODO
                icon: Icons.repeat,
                iconSize: 40,
                padding: EdgeInsets.zero,
              ),
            ],
          ),
        ],
      );
}
