import 'package:flutter/material.dart';
import 'package:myoro_player/widgets/shared/buttons/base_hover_button.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final ScrollController _controller = ScrollController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Container(
        width: 200,
        constraints: const BoxConstraints(minWidth: 200),
        child: LayoutBuilder(
          builder: (context, constraints) => Scrollbar(
            controller: _controller,
            thumbVisibility: true,
            child: SingleChildScrollView(
              controller: _controller,
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
      );
}
