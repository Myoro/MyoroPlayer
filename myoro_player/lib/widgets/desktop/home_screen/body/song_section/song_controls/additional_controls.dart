import 'package:flutter/material.dart';
import 'package:myoro_player/widgets/shared/buttons/base_hover_button.dart';
import 'package:myoro_player/widgets/shared/buttons/base_slider.dart';

/// Queue button and volume slider
class AdditionalControls extends StatelessWidget {
  const AdditionalControls({super.key});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          BaseHoverButton(
            onTap: () {}, // TODO
            icon: Icons.queue_music,
            iconSize: 40,
          ),
          const BaseSlider(width: 200),
        ],
      );
}
