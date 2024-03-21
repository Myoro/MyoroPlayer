import 'package:flutter/material.dart';
import 'package:myoro_player/shared/design_system/icon_design_system.dart';
import 'package:myoro_player/shared/enums/divider_type_enum.dart';
import 'package:myoro_player/shared/widgets/buttons/hover_button.dart';
import 'package:myoro_player/shared/widgets/dividers/basic_divider.dart';
import 'package:myoro_player/shared/widgets/dividers/resize_divider.dart';

class PlaylistSideBar extends StatefulWidget {
  const PlaylistSideBar({super.key});

  @override
  State<PlaylistSideBar> createState() => _PlaylistSideBarState();
}

class _PlaylistSideBarState extends State<PlaylistSideBar> {
  final ValueNotifier<double> _width = ValueNotifier<double>(200);

  @override
  void dispose() {
    _width.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => Row(
        children: [
          ValueListenableBuilder(
            valueListenable: _width,
            builder: (context, width, constraints) => Container(
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
                  const SizedBox(height: 5),
                  const Padding(
                    padding: EdgeInsets.symmetric(horizontal: 15),
                    child: BasicDivider(
                      dividerTypeEnum: DividerTypeEnum.horizontal,
                    ),
                  ),
                  const SizedBox(height: 5),
                  Expanded(
                    child: SingleChildScrollView(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 15),
                        child: Column(
                          children: [
                            // TODO: Remove loop
                            for (int i = 0; i < 10; i++) ...[
                              HoverButton(
                                onTap: () {}, // TODO
                                svgPath: IconDesignSystem.logo,
                                iconSize: 30,
                                text: 'Playlistqwjeoiqjeqoiwje Button',
                              ),
                              const SizedBox(height: 10),
                            ],
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(right: 13),
            child: ResizeDivider(
              dividerTypeEnum: DividerTypeEnum.vertical,
              padding: 8,
              onHorizontalDragUpdate: (details) =>
                  _width.value += details.delta.dx,
            ),
          ),
        ],
      );
}
