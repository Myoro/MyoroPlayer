import 'package:flutter/material.dart';
import 'package:myoro_player/widgets/shared/buttons/base_hover_button.dart';
import 'package:myoro_player/widgets/shared/dividers/vertical_divider.dart';

class SideBar extends StatefulWidget {
  const SideBar({super.key});

  @override
  State<SideBar> createState() => _SideBarState();
}

class _SideBarState extends State<SideBar> {
  final ScrollController _controller = ScrollController();
  final ValueNotifier<double> _sideBarWidth = ValueNotifier<double>(200);

  @override
  void dispose() {
    _controller.dispose();
    _sideBarWidth.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          ValueListenableBuilder(
            valueListenable: _sideBarWidth,
            builder: (context, sideBarWidth, child) => Container(
              width: sideBarWidth,
              height: double.infinity,
              constraints: BoxConstraints(
                minWidth: 200,
                maxWidth: MediaQuery.of(context).size.width - 100.5,
              ),
              child: LayoutBuilder(
                builder: (context, constraints) => Scrollbar(
                  controller: _controller,
                  thumbVisibility: true,
                  child: SingleChildScrollView(
                    controller: _controller,
                    child: Padding(
                      padding: const EdgeInsets.only(left: 5, right: 15),
                      child: Column(
                        children: [
                          for (int i = 0; i < 20; i++)
                            BaseHoverButton(
                              onTap: () {}, // TODO
                              text: '${'*' * i} Playlist',
                              ellipsize: true,
                              textWidth: constraints.maxWidth - 40,
                            ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ),
          BaseVerticalDivider(
            isResizeButton: true,
            onHorizontalDragUpdate: (value) =>
                _sideBarWidth.value = _sideBarWidth.value + value,
          ),
        ],
      );
}
