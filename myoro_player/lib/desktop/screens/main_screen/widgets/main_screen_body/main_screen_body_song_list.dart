import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_footer_bloc/main_screen_body_footer_event.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_bloc.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_state.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_footer_bloc/main_screen_body_footer_bloc.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_footer_bloc/main_screen_body_footer_state.dart';
import 'package:myoro_player/desktop/screens/main_screen/enums/main_screen_body_song_list_context_menu_enum.dart';
import 'package:myoro_player/shared/constants.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/design_system/image_design_system.dart';
import 'package:myoro_player/shared/enums/bloc_status_enum.dart';
import 'package:myoro_player/shared/enums/image_size_enum.dart';
import 'package:myoro_player/shared/extensions/build_context_extension.dart';
import 'package:myoro_player/shared/extensions/duration_extension.dart';
import 'package:myoro_player/shared/extensions/text_style_extension.dart';
import 'package:myoro_player/shared/models/song.dart';
import 'package:myoro_player/shared/widgets/buttons/base_hover_button.dart';
import 'package:myoro_player/shared/widgets/headers/underline_header.dart';
import 'package:myoro_player/shared/widgets/images/base_image.dart';
import 'package:myoro_player/shared/widgets/inputs/underline_input.dart';
import 'package:myoro_player/shared/widgets/loading/loading_circle.dart';
import 'package:myoro_player/shared/widgets/scrollbars/vertical_scrollbar.dart';

final class MainScreenBodySongList extends StatefulWidget {
  const MainScreenBodySongList({super.key});

  @override
  State<MainScreenBodySongList> createState() => _MainScreenBodySongListState();
}

class _MainScreenBodySongListState extends State<MainScreenBodySongList> {
  final _searchBarController = TextEditingController();
  final _filteredSongsNotifier = ValueNotifier<List<Song>>([]);

  /// "Cached" songs from [MainScreenBodySongListBloc]
  List<Song>? _loadedPlaylistSongs;

  @override
  void initState() {
    super.initState();
    _searchBarController.addListener(() => _searchSongs());
  }

  @override
  void dispose() {
    _searchBarController.dispose();
    _filteredSongsNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: BlocConsumer<MainScreenBodySongListBloc, MainScreenBodySongListState>(
        listener: (context, mainScreenBodySongListState) {
          _filteredSongsNotifier.value = mainScreenBodySongListState.loadedPlaylistSongs ?? [];
          _loadedPlaylistSongs = mainScreenBodySongListState.loadedPlaylistSongs;

          _handleSnackBars(context, mainScreenBodySongListState);
        },
        builder: (context, mainScreenBodySongListState) {
          return Column(
            children: [
              UnderlineHeader(header: mainScreenBodySongListState.loadedPlaylist?.name ?? ''),
              BlocBuilder<MainScreenBodyFooterBloc, MainScreenBodyFooterState>(
                builder: (context, mainScreenFooterState) {
                  return Expanded(
                    child: mainScreenBodySongListState.status == BlocStatusEnum.loading
                        ? const Center(child: LoadingCircle())
                        : ValueListenableBuilder(
                            valueListenable: _filteredSongsNotifier,
                            builder: (_, List<Song> filteredSongs, __) {
                              return VerticalScrollbar(
                                children: [
                                  UnderlineInput(
                                    controller: _searchBarController,
                                    placeholder: 'Search songs',
                                  ),
                                  ...filteredSongs.map<_Song>(
                                    (song) {
                                      return _Song(
                                        song,
                                        isLastSong: mainScreenBodySongListState.loadedPlaylistSongs?.last == song,
                                        isSelectedSong: mainScreenFooterState.loadedSong?.$1 == song,
                                      );
                                    },
                                  ),
                                ],
                              );
                            },
                          ),
                  );
                },
              ),
            ],
          );
        },
      ),
    );
  }

  // coverage:ignore-start
  void _handleSnackBars(BuildContext context, MainScreenBodySongListState state) {
    if (state.status == BlocStatusEnum.completed && state.snackBarMessage != null) {
      context.showDialogSnackBar(context, state.snackBarMessage!);
    } else if (state.status == BlocStatusEnum.error) {
      context.showErrorSnackBar(context, state.snackBarMessage!);
    }
  }
  // coverage:ignore-end

  void _searchSongs() {
    if (_searchBarController.text.isEmpty) {
      _filteredSongsNotifier.value = _loadedPlaylistSongs ?? [];
      return;
    }

    final query = _searchBarController.text.toUpperCase();
    _filteredSongsNotifier.value = (_loadedPlaylistSongs ?? [])
        .where(
          (song) =>
              song.title.toUpperCase().contains(query) ||
              (song.artist?.toUpperCase().contains(query) ?? false) ||
              (song.album?.toUpperCase().contains(query) ?? false),
        )
        .toList();
  }
}

final class _Song extends StatelessWidget {
  final Song song;
  final bool isLastSong;
  final bool isSelectedSong;

  const _Song(
    this.song, {
    required this.isLastSong,
    required this.isSelectedSong,
  });

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = context.textTheme;

    return Padding(
      padding: EdgeInsets.only(
        top: 5,
        bottom: isLastSong ? 5 : 0,
      ),
      child: Tooltip(
        waitDuration: kTooltipWaitDuration,
        message: song.path,
        child: BaseHoverButton(
          forceHover: isSelectedSong,
          onTap: () => BlocProvider.of<MainScreenBodyFooterBloc>(context).add(
            DirectPlayEvent(
              song,
            ),
          ),
          onSecondaryTapDown: (details) {
            MainScreenBodySongListContextMenuEnum.showContextMenu(
              context,
              details,
              song,
            );
          },
          padding: const EdgeInsets.only(
            top: 5,
            bottom: 5,
            left: 8,
            right: 5,
          ),
          builder: (hovered) {
            // coverage:ignore-start
            final Color contentColor = isSelectedSong
                ? ColorDesignSystem.background(context)
                : hovered
                    ? ColorDesignSystem.background(context)
                    : ColorDesignSystem.onBackground(context);
            // coverage:ignore-end
            final TextStyle bodyMedium = textTheme.bodyMedium!.withColor(contentColor);
            final TextStyle bodySmall = textTheme.bodySmall!.withColor(contentColor);

            return Row(
              children: [
                BaseImage(
                  svgPath: song.cover == null ? ImageDesignSystem.logo : null,
                  svgColor: contentColor,
                  blob: song.cover,
                  size: ImageSizeEnum.small.size + 10,
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        song.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: bodyMedium,
                      ),
                      if (song.artist != null)
                        Text(
                          song.artist!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: bodySmall,
                        ),
                    ],
                  ),
                ),
                const SizedBox(width: 10),
                if (song.album != null) ...[
                  Expanded(
                    child: Text(
                      song.album!,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: bodySmall,
                    ),
                  ),
                  const SizedBox(width: 10),
                ],
                Text(
                  song.duration.hhMmSsFormat,
                  style: bodyMedium,
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
