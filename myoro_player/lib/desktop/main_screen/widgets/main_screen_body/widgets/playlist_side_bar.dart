import 'package:flutter/material.dart';
import 'package:myoro_player/shared/enums/divider_type_enum.dart';
import 'package:myoro_player/shared/widgets/buttons/hover_button.dart';
import 'package:myoro_player/shared/widgets/dividers/resize_divider.dart';

class PlaylistSideBar extends StatefulWidget {
  const PlaylistSideBar({super.key});

  @override
  State<PlaylistSideBar> createState() => _PlaylistSideBarState();
}

class _PlaylistSideBarState extends State<PlaylistSideBar> {
  final ValueNotifier<double> _width = ValueNotifier<double>(200);

  @override
  Widget build(BuildContext context) => Row(
        children: [
          ValueListenableBuilder(
            valueListenable: _width,
            builder: (context, width, child) => Padding(
              padding: const EdgeInsets.only(left: 5),
              child: LayoutBuilder(
                builder: (context, constraints) => Container(
                  width: width,
                  constraints: const BoxConstraints(
                    minWidth: 100,
                    maxWidth: double.infinity,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'Playlists',
                        style: Theme.of(context).textTheme.titleSmall,
                      ),
                      SizedBox(
                        width: double.infinity,
                        child: HoverButton(
                          onTap: () {}, // TODO
                          icon: Icons.abc,
                          iconSize: 40,
                          text: 'Playlist Button',
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          ResizeDivider(
            dividerTypeEnum: DividerTypeEnum.vertical,
            padding: 10,
            onHorizontalDragUpdate: (details) =>
                _width.value += details.delta.dx,
          ),
        ],
      );
}
