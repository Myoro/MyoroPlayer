import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/shared/blocs/song_controls_bloc/song_controls_bloc.dart';
import 'package:myoro_player/shared/blocs/song_controls_bloc/song_controls_event.dart';
import 'package:myoro_player/shared/blocs/song_controls_bloc/song_controls_state.dart';
import 'package:myoro_player/shared/blocs/user_preferences_cubit.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/design_system/decoration_design_system.dart';
import 'package:myoro_player/shared/design_system/image_design_system.dart';
import 'package:myoro_player/shared/enums/image_size_enum.dart';
import 'package:myoro_player/shared/extensions/build_context_extension.dart';
import 'package:myoro_player/shared/extensions/text_style_extension.dart';
import 'package:myoro_player/shared/models/song.dart';
import 'package:myoro_player/shared/models/user_preferences.dart';
import 'package:myoro_player/shared/widgets/buttons/base_hover_button.dart';
import 'package:myoro_player/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:myoro_player/shared/widgets/images/base_image.dart';
import 'package:myoro_player/shared/widgets/scrollbars/vertical_scroll_list.dart';
import 'package:myoro_player/shared/widgets/sliders/base_slider.dart';
import 'package:kplayer/kplayer.dart';

final class MainScreenBodyFooter extends StatelessWidget {
  const MainScreenBodyFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      padding: const EdgeInsets.symmetric(
        horizontal: 15,
      ),
      child: LayoutBuilder(
        builder: (context, constraints) {
          final bool showSideWidgets = constraints.maxWidth >= 665;
          final sideWidgetWidths = constraints.maxWidth / 3;

          return BlocBuilder<SongControlsBloc, SongControlsState>(
            builder: (context, mainScreenBodyFooterState) {
              return Row(
                children: [
                  if (showSideWidgets) _SongInformation(mainScreenBodyFooterState, width: sideWidgetWidths),
                  _MainScreenBodyFooter(mainScreenBodyFooterState),
                  if (showSideWidgets) _MiscControls(mainScreenBodyFooterState, width: sideWidgetWidths),
                ],
              );
            },
          );
        },
      ),
    );
  }
}

final class _SongInformation extends StatelessWidget {
  final SongControlsState mainScreenBodyFooterState;
  final double width;

  const _SongInformation(this.mainScreenBodyFooterState, {required this.width});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = context.textTheme;

    return SizedBox(
      width: width,
      child: Row(
        children: [
          BaseImage(
            svgPath: mainScreenBodyFooterState.loadedSong == null || mainScreenBodyFooterState.loadedSong?.$1.cover == null ? ImageDesignSystem.logo : null,
            svgColor: ColorDesignSystem.onBackground(context),
            blob: mainScreenBodyFooterState.loadedSong?.$1.cover,
            size: ImageSizeEnum.small.size + 10,
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  mainScreenBodyFooterState.loadedSong?.$1.title ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium,
                ),
                // coverage:ignore-start
                if (mainScreenBodyFooterState.loadedSong?.$1.artist != null)
                  Text(
                    mainScreenBodyFooterState.loadedSong?.$1.artist ?? '',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: textTheme.bodySmall,
                  ),
                // coverage:ignore-end
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _MainScreenBodyFooter extends StatefulWidget {
  final SongControlsState mainScreenBodyFooterState;

  const _MainScreenBodyFooter(this.mainScreenBodyFooterState);

  @override
  State<_MainScreenBodyFooter> createState() => _MainScreenBodyFooterState();
}

class _MainScreenBodyFooterState extends State<_MainScreenBodyFooter> with PlayerStateMixin {
  SongControlsState get _mainScreenBodyFooterState => widget.mainScreenBodyFooterState;

  final _songPositionNotifier = ValueNotifier<double?>(null);
  final _isPlayingNotifier = ValueNotifier<bool>(false);

  @override
  void initState() {
    usePlayer(_mainScreenBodyFooterState.player);
    super.initState();
  }

  @override
  void dispose() {
    _songPositionNotifier.dispose();
    _isPlayingNotifier.dispose();
    super.dispose();
  }

  // coverage:ignore-start
  @override
  void didUpdateWidget(covariant _MainScreenBodyFooter oldWidget) {
    super.didUpdateWidget(oldWidget);
    usePlayer(_mainScreenBodyFooterState.player);
  }

  @override
  void onPositionChanged(Duration position) {
    _songPositionNotifier.value = position.inSeconds.toDouble();
  }

  @override
  void onStatusChanged(PlayerStatus status) {
    _isPlayingNotifier.value = status == PlayerStatus.playing ? true : false;

    if (status == PlayerStatus.ended) {
      BlocProvider.of<SongControlsBloc>(context).add(
        const NextSongEvent(),
      );
    }
  }
  // coverage:ignore-end

  @override
  Widget build(BuildContext context) {
    final userPreferencesCubit = BlocProvider.of<UserPreferencesCubit>(context);
    final mainScreenBodyFooterBloc = BlocProvider.of<SongControlsBloc>(context);

    return Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ValueListenableBuilder(
            valueListenable: _songPositionNotifier,
            builder: (_, double? position, __) {
              return BaseSlider(
                width: 190,
                max: _mainScreenBodyFooterState.loadedSong?.$1.duration.inSeconds.toDouble(),
                value: position,
                onChanged: (value) => BlocProvider.of<SongControlsBloc>(context).add(
                  ChangeSongPositionEvent(
                    value,
                  ),
                ),
              );
            },
          ),
          const SizedBox(height: 1),
          BlocBuilder<UserPreferencesCubit, UserPreferences>(
            builder: (context, userPreferences) {
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _Button(
                    icon: Icons.shuffle,
                    forceHover: userPreferences.shuffle,
                    onPressed: () => userPreferencesCubit.toggleShuffle(),
                  ),
                  const SizedBox(width: 1),
                  _Button(
                    icon: Icons.skip_previous,
                    onPressed: () => mainScreenBodyFooterBloc.add(const PreviousSongEvent()),
                  ),
                  const SizedBox(width: 1),
                  ValueListenableBuilder(
                    valueListenable: _isPlayingNotifier,
                    builder: (_, bool isPlaying, __) {
                      return _Button(
                        icon: isPlaying ? Icons.pause : Icons.play_arrow,
                        onPressed: () => mainScreenBodyFooterBloc.add(const TogglePlayPauseEvent()),
                      );
                    },
                  ),
                  const SizedBox(width: 1),
                  _Button(
                    icon: Icons.skip_next,
                    onPressed: () => mainScreenBodyFooterBloc.add(const NextSongEvent()),
                  ),
                  const SizedBox(width: 1),
                  _Button(
                    icon: Icons.repeat,
                    forceHover: userPreferences.repeat,
                    onPressed: () => userPreferencesCubit.toggleRepeat(),
                  ),
                ],
              );
            },
          ),
        ],
      ),
    );
  }
}

final class _MiscControls extends StatelessWidget {
  final SongControlsState mainScreenBodyFooterState;
  final double width;

  const _MiscControls(this.mainScreenBodyFooterState, {required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: BlocBuilder<UserPreferencesCubit, UserPreferences>(
        builder: (context, userPreferences) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              const _QueueButton(),
              const SizedBox(width: 5),
              BaseSlider(
                width: width >= 180 ? 180 : width,
                value: userPreferences.volume * 100,
                max: 100,
                onChanged: (value) => BlocProvider.of<SongControlsBloc>(context).add(
                  ChangeVolumeEvent(
                    value / 100,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

final class _Button extends StatelessWidget {
  final IconData icon;
  final bool forceHover;
  final VoidCallback onPressed;

  const _Button({
    required this.icon,
    this.forceHover = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconTextHoverButton(
      icon: icon,
      iconSize: ImageSizeEnum.small.size,
      forceHover: forceHover,
      onTap: onPressed,
    );
  }
}

final class _QueueButton extends StatefulWidget {
  const _QueueButton();

  @override
  State<_QueueButton> createState() => _QueueButtonState();
}

class _QueueButtonState extends State<_QueueButton> with SingleTickerProviderStateMixin {
  static const int _animationDuration = 200;
  OverlayEntry? _overlayEntry;
  late final AnimationController _animationController;
  late final Animation<double> _animation;
  final _queueNotifier = ValueNotifier<List<Song>>([]); // Used to order the queue

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: _animationDuration),
    );
    _animation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _hideOverlay();
    _animationController.dispose();
    _queueNotifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _Button(
      icon: Icons.queue_music,
      onPressed: () {
        if (_overlayEntry == null) {
          _showOverlay();
        }
      },
    );
  }

  void _showOverlay() {
    _hideOverlay();

    _overlayEntry = OverlayEntry(
      builder: (context) {
        final screenWidth = MediaQuery.of(context).size.width;
        final background = ColorDesignSystem.background(context);
        final onBackground = ColorDesignSystem.onBackground(context);
        final textTheme = Theme.of(context).textTheme;

        return GestureDetector(
          onTap: () => _hideOverlay(),
          child: Stack(
            children: [
              // Used to trigger the [GestureDetector] [onTap]
              Container(color: Colors.transparent),
              Positioned(
                left: screenWidth - 410,
                bottom: 95,
                child: AnimatedBuilder(
                  animation: _animationController,
                  builder: (_, __) {
                    return FadeTransition(
                      opacity: _animation,
                      child: Container(
                        width: 375,
                        height: 300,
                        decoration: BoxDecoration(
                          color: background,
                          borderRadius: DecorationDesignSystem.borderRadius,
                          border: Border.all(
                            width: 2,
                            color: onBackground,
                          ),
                        ),
                        child: BlocBuilder<SongControlsBloc, SongControlsState>(
                          builder: (context, state) {
                            _queueNotifier.value = List.from(state.queue);

                            return Material(
                              borderRadius: DecorationDesignSystem.borderRadius,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                  vertical: 5,
                                ),
                                child: ValueListenableBuilder(
                                  valueListenable: _queueNotifier,
                                  builder: (_, List<Song> queue, __) {
                                    return VerticalScrollList(
                                      children: queue.map(
                                        (song) {
                                          return Padding(
                                            padding: EdgeInsets.only(
                                              top: 5,
                                              bottom: song == queue.last ? 5 : 0,
                                            ),
                                            child: BaseHoverButton(
                                              // coverage:ignore-start
                                              onTap: () => _playQueuedSong(song),
                                              // coverage:ignore-end
                                              padding: const EdgeInsets.only(
                                                top: 5,
                                                bottom: 5,
                                                left: 8,
                                                right: 5,
                                              ),
                                              builder: (bool hovered) {
                                                // coverage:ignore-start
                                                final Color contentColor =
                                                    hovered ? ColorDesignSystem.background(context) : ColorDesignSystem.onBackground(context);
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
                                                    BaseHoverButton(
                                                      onTap: () => _moveSongUp(song),
                                                      disableHover: true,
                                                      builder: (bool moveUpButtonHovered) {
                                                        return Container(
                                                          decoration: BoxDecoration(
                                                            color: moveUpButtonHovered ? background : ColorDesignSystem.transparent,
                                                            borderRadius: DecorationDesignSystem.borderRadius,
                                                          ),
                                                          child: Icon(
                                                            Icons.arrow_upward,
                                                            size: ImageSizeEnum.small.size,
                                                            color: moveUpButtonHovered
                                                                ? onBackground
                                                                : hovered
                                                                    ? background
                                                                    : onBackground,
                                                          ),
                                                        );
                                                      },
                                                    ),
                                                  ],
                                                );
                                              },
                                            ),
                                          );
                                        },
                                      ).toList(),
                                    );
                                  },
                                ),
                              ),
                            );
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        );
      },
    );

    Overlay.of(context).insert(_overlayEntry!);
    _animationController.reset();
    _animationController.forward();
  }

  void _hideOverlay() {
    if (_overlayEntry == null) return;
    _animationController.reverse().then((_) {
      if (!_animationController.isAnimating) {
        _overlayEntry?.remove();
        _overlayEntry?.dispose();
        _overlayEntry = null;
      }
    });
  }

  // coverage:ignore-start
  void _playQueuedSong(Song song) {
    BlocProvider.of<SongControlsBloc>(context).add(
      PlayQueuedSongEvent(
        song,
      ),
    );
    _hideOverlay();
  }
  // coverage:ignore-end

  void _moveSongUp(Song song) {
    final List<Song> arrangedQueue = List.from(_queueNotifier.value);
    final int songIndex = arrangedQueue.indexOf(song);
    if (song == arrangedQueue.first) return;
    final Song temp = arrangedQueue[songIndex - 1];
    arrangedQueue[songIndex - 1] = song;
    arrangedQueue[songIndex] = temp;
    _queueNotifier.value = arrangedQueue;
  }
}
