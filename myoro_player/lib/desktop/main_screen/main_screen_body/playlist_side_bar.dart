import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/shared/blocs/playlist_cubit.dart';
import 'package:myoro_player/shared/design_system/svg_design_system.dart';
import 'package:myoro_player/shared/enums/divider_type_enum.dart';
import 'package:myoro_player/shared/models/playlist.dart';
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
  Widget build(BuildContext context) => BlocBuilder<PlaylistCubit, List<Playlist>>(
        builder: (context, playlists) => Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ValueListenableBuilder(
              valueListenable: _width,
              builder: (context, width, child) => Container(
                width: width,
                constraints: BoxConstraints(
                  minWidth: 100,
                  maxWidth: MediaQuery.of(context).size.width - 200,
                ),
                child: Column(
                  children: [
                    Padding(
                      /// Offset scrollbar offset [Padding] below
                      padding: const EdgeInsets.only(right: 15),
                      child: Column(
                        children: [
                          Text(
                            'Playlists',
                            style: Theme.of(context).textTheme.titleMedium,
                          ),
                          const SizedBox(height: 5),
                          const BasicDivider(
                            dividerType: DividerTypeEnum.horizontal,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 5),
                    Expanded(
                      child: SingleChildScrollView(
                        child: Padding(
                          // Offset scrollbar
                          padding: const EdgeInsets.only(right: 15),
                          child: Column(
                            children: [
                              for (final Playlist playlist in playlists) ...[
                                HoverButton(
                                  // TODO: onTap: () => BlocProvider.of<SongCubit>(context).openPlaylist(playlist.directory),
                                  onTap: () {},
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 10,
                                    vertical: 5,
                                  ),
                                  svgPath: SvgDesignSystem.logo,
                                  iconSize: 30,
                                  text: playlist.name,
                                ),
                                const SizedBox(height: 5),
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
              padding: const EdgeInsets.only(
                top: 30,
                bottom: 5,
              ),
              child: ResizeDivider(
                dividerType: DividerTypeEnum.vertical,
                padding: 15,
                onHorizontalDragUpdate: (details) => _width.value += details.delta.dx,
              ),
            ),
          ],
        ),
      );
}
