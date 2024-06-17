import 'package:flutter/material.dart';
import 'package:frontend/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:frontend/shared/widgets/dividers/resize_divider.dart';
import 'package:frontend/shared/widgets/titles/underline_title.dart';

final class MainScreenBodyPlaylistSideBar extends StatefulWidget {
  const MainScreenBodyPlaylistSideBar({super.key});

  @override
  State<MainScreenBodyPlaylistSideBar> createState() => _MainScreenBodyPlaylistSideBarState();
}

class _MainScreenBodyPlaylistSideBarState extends State<MainScreenBodyPlaylistSideBar> {
  final _widthNotifier = ValueNotifier<double>(173);

  @override
  void dispose() {
    _widthNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _widthNotifier,
      builder: (context, width, _) {
        return Container(
          width: width,
          constraints: BoxConstraints(
            minWidth: 173,
            maxWidth: MediaQuery.of(context).size.width - 100,
          ),
          child: Row(
            children: [
              const _Playlists(),
              ResizeDivider(
                direction: Axis.vertical,
                onHorizontalDragUpdate: (details) => _widthNotifier.value += details.delta.dx,
                padding: const EdgeInsets.only(
                  top: 40,
                  bottom: 10,
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}

final class _Playlists extends StatelessWidget {
  const _Playlists();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const UnderlineTitle(text: 'Playlists'),
          // TODO
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < 50; i++) ...[
                      const SizedBox(height: 5),
                      IconTextHoverButton(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 5,
                        ),
                        icon: Icons.music_note,
                        text: 'Playlist name',
                        onTap: () => print('TODO'),
                      ),
                      if (i == 49) const SizedBox(height: 5),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
