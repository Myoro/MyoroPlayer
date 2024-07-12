import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_bloc.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_state.dart';
import 'package:frontend/screens/main_screen/enums/main_screen_body_song_list_context_menu_enum.dart';
import 'package:frontend/shared/controllers/song_controller.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/design_system/image_design_system.dart';
import 'package:frontend/shared/enums/bloc_status_enum.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/extensions/build_context_extension.dart';
import 'package:frontend/shared/extensions/duration_extension.dart';
import 'package:frontend/shared/extensions/text_style_extension.dart';
import 'package:frontend/shared/models/song.dart';
import 'package:frontend/shared/widgets/buttons/base_hover_button.dart';
import 'package:frontend/shared/widgets/headers/underline_header.dart';
import 'package:frontend/shared/widgets/images/base_image.dart';
import 'package:frontend/shared/widgets/loading/loading_circle.dart';
import 'package:frontend/shared/widgets/scrollbars/vertical_scrollbar.dart';
import 'package:kiwi/kiwi.dart';

final class MainScreenBodySongList extends StatelessWidget {
  const MainScreenBodySongList({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final songController = KiwiContainer().resolve<SongController>();

    return Expanded(
      child: BlocConsumer<MainScreenBodySongListBloc, MainScreenBodySongListState>(
        listener: (context, state) => _handleSnackBars(context, state),
        builder: (context, state) {
          return Column(
            children: [
              UnderlineHeader(header: state.loadedPlaylist?.name ?? ''),
              ListenableBuilder(
                listenable: songController,
                builder: (_, __) {
                  return Expanded(
                    child: state.status == BlocStatusEnum.loading
                        ? const Center(child: LoadingCircle())
                        : VerticalScrollbar(
                            children: state.loadedPlaylistSongs?.map<_Song>(
                                  (song) {
                                    return _Song(
                                      song,
                                      isLastSong: state.loadedPlaylistSongs?.last == song,
                                      isSelectedSong: songController.loadedSong == song,
                                    );
                                  },
                                ).toList() ??
                                [],
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
      child: BaseHoverButton(
        forceHover: isSelectedSong,
        onTap: () => KiwiContainer().resolve<SongController>().directPlay(song),
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
    );
  }
}
