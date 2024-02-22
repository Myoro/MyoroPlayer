import 'package:flutter/material.dart';
import 'package:myoro_player/widgets/shared/buttons/base_hover_button.dart';
import 'package:myoro_player/widgets/shared/buttons/icon_button_without_feedback.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) => Row(
        children: [
          Container(
            width: 200,
            constraints: const BoxConstraints(minWidth: 200),
            child: LayoutBuilder(
              builder: (context, constraints) => SingleChildScrollView(
                child: Padding(
                  padding: const EdgeInsets.only(left: 5, right: 15),
                  child: Column(children: [
                    for (int i = 0; i < 20; i++)
                      BaseHoverButton(
                        onTap: () {}, // TODO
                        text: '${'*' * i} Playlist',
                        ellipsize: true,
                        textWidth: constraints.maxWidth - 40,
                      ),
                  ]),
                ),
              ),
            ),
          ),
          IconButtonWithoutFeedback(
            onTap: () {}, // TODO
            icon: Icons.arrow_forward_ios,
            size: 20,
          ),
        ],
      );
}
