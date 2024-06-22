import 'package:flutter/material.dart';
import 'package:myoro_player/shared/enums/image_size_enum.dart';
import 'package:myoro_player/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:myoro_player/shared/widgets/dividers/resize_divider.dart';
import 'package:myoro_player/shared/widgets/headers/underline_header.dart';
import 'package:myoro_player/shared/widgets/scrollbars/vertical_scrollbar.dart';

final class MainScreenBodyPlaylistSideBar extends StatefulWidget {
  const MainScreenBodyPlaylistSideBar({super.key});

  @override
  State<MainScreenBodyPlaylistSideBar> createState() => _MainScreenBodyPlaylistSideBarState();
}

class _MainScreenBodyPlaylistSideBarState extends State<MainScreenBodyPlaylistSideBar> {
  final double _minWidth = 180;
  late final ValueNotifier<double> _widthNotifier;

  @override
  void initState() {
    super.initState();
    _widthNotifier = ValueNotifier<double>(_minWidth);
  }

  @override
  void dispose() {
    _widthNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: _widthNotifier,
      builder: (context, width, child) {
        return Container(
          width: width,
          constraints: BoxConstraints(
            minWidth: _minWidth,
            maxWidth: MediaQuery.of(context).size.width - 300,
          ),
          child: Row(
            children: [
              _Playlists(),
              _ResizeDivider(_widthNotifier),
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
          UnderlineHeader(header: 'Playlists'),
          Expanded(
            child: VerticalScrollbar(
              children: List.generate(
                50,
                (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                      bottom: index == 49 ? 5 : 0,
                    ),
                    child: IconTextHoverButton(
                      icon: Icons.music_note,
                      iconSize: ImageSizeEnum.small.size + 10,
                      text: 'Playlist #$index',
                      onTap: () {},
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _ResizeDivider extends StatelessWidget {
  final ValueNotifier<double> widthNotifier;

  const _ResizeDivider(this.widthNotifier);

  @override
  Widget build(BuildContext context) {
    return ResizeDivider(
      direction: Axis.vertical,
      resizeCallback: (details) => widthNotifier.value += details.delta.dx,
      padding: const EdgeInsets.only(
        top: 40,
        bottom: 15,
      ),
    );
  }
}
