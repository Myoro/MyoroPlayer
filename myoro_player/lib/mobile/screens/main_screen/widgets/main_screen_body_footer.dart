import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kplayer/kplayer.dart';
import 'package:myoro_player/core/design_system/color_design_system.dart';
import 'package:myoro_player/core/design_system/image_design_system.dart';
import 'package:myoro_player/core/enums/image_size_enum.dart';
import 'package:myoro_player/core/extensions/duration_extension.dart';
import 'package:myoro_player/core/models/song.dart';
import 'package:myoro_player/core/models/user_preferences.dart';
import 'package:myoro_player/core/widgets/buttons/icon_text_hover_button.dart';
import 'package:myoro_player/core/widgets/dividers/basic_divider.dart';
import 'package:myoro_player/core/widgets/images/base_image.dart';
import 'package:myoro_player/core/widgets/sliders/base_slider.dart';
import 'package:myoro_player/shared/blocs/song_controls_bloc/song_controls_bloc.dart';
import 'package:myoro_player/shared/blocs/song_controls_bloc/song_controls_event.dart';
import 'package:myoro_player/shared/blocs/song_controls_bloc/song_controls_state.dart';
import 'package:myoro_player/shared/blocs/user_preferences_cubit.dart';
import 'package:text_scroll/text_scroll.dart';

/// Footer that also doubles as a mini-screen
final class MainScreenBodyFooter extends StatelessWidget {
  const MainScreenBodyFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<SongControlsBloc, SongControlsState>(
      builder: (context, state) {
        if (state.loadedSong?.$1 == null) {
          return const SizedBox.shrink();
        } else {
          return _Footer(state);
        }
      },
    );
  }
}

final class _Footer extends StatefulWidget {
  final SongControlsState songControlsState;

  const _Footer(this.songControlsState);

  @override
  State<_Footer> createState() => _FooterState();
}

class _FooterState extends State<_Footer> with PlayerStateMixin {
  late final SongControlsState _songControlsState;
  final _isPlayingNotifier = ValueNotifier<bool>(false);
  final _songPositionNotifier = ValueNotifier<double?>(null);

  @override
  void initState() {
    _songControlsState = widget.songControlsState;
    usePlayer(_songControlsState.player);
    super.initState();
  }

  @override
  void dispose() {
    _isPlayingNotifier.dispose();
    _songPositionNotifier.dispose();
    super.dispose();
  }

  // coverage:ignore-start
  @override
  void didUpdateWidget(covariant _Footer oldWidget) {
    super.didUpdateWidget(oldWidget);
    usePlayer(_songControlsState.player);
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
    final Song song = _songControlsState.loadedSong!.$1;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const BasicDivider(
            direction: Axis.horizontal,
            padding: EdgeInsets.only(
              bottom: 10,
            ),
          ),
          _Song(song),
          const BasicDivider(
            direction: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
          ),
          _Controls(
            song,
            _isPlayingNotifier,
            _songPositionNotifier,
            _songControlsState,
          ),
        ],
      ),
    );
  }
}

final class _SongControlButton extends StatelessWidget {
  final IconData icon;
  final bool forceHover;
  final VoidCallback onPressed;

  const _SongControlButton({
    required this.icon,
    this.forceHover = false,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return IconTextHoverButton(
      icon: icon,
      iconSize: ImageSizeEnum.small.size + 10,
      forceHover: forceHover,
      onTap: onPressed,
    );
  }
}

final class _Song extends StatelessWidget {
  final Song song;

  const _Song(this.song);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodySmall = textTheme.bodySmall;
    final bodyMedium = textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 10),
      child: Row(
        children: [
          BaseImage(
            svgPath: song.cover == null ? ImageDesignSystem.logo : null,
            svgColor: ColorDesignSystem.onBackground(context),
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
                TextScroll(
                  song.title,
                  style: bodyMedium,
                  velocity: const Velocity(pixelsPerSecond: Offset(20, 0)),
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
          Text(
            song.duration.hhMmSsFormat,
            style: bodyMedium,
          ),
        ],
      ),
    );
  }
}

final class _Controls extends StatelessWidget {
  final Song song;
  final ValueNotifier<bool> isPlayingNotifier;
  final ValueNotifier<double?> songPositionNotifier;
  final SongControlsState songControlsState;

  const _Controls(
    this.song,
    this.isPlayingNotifier,
    this.songPositionNotifier,
    this.songControlsState,
  );

  @override
  Widget build(BuildContext context) {
    final userPreferencesCubit = BlocProvider.of<UserPreferencesCubit>(context);
    final songControlsBloc = BlocProvider.of<SongControlsBloc>(context);

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        ValueListenableBuilder(
          valueListenable: songPositionNotifier,
          builder: (_, double? position, __) {
            return BaseSlider(
              width: 190,
              max: songControlsState.loadedSong?.$1.duration.inSeconds.toDouble(),
              value: position,
              onChanged: (value) => BlocProvider.of<SongControlsBloc>(context).add(
                ChangeSongPositionEvent(
                  value,
                ),
              ),
            );
          },
        ),
        BlocBuilder<UserPreferencesCubit, UserPreferences>(
          builder: (context, userPreferences) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _SongControlButton(
                  icon: Icons.shuffle,
                  forceHover: userPreferences.shuffle,
                  onPressed: () => userPreferencesCubit.toggleShuffle(),
                ),
                const SizedBox(width: 3),
                _SongControlButton(
                  icon: Icons.skip_previous,
                  onPressed: () => songControlsBloc.add(const PreviousSongEvent()),
                ),
                const SizedBox(width: 3),
                ValueListenableBuilder(
                  valueListenable: isPlayingNotifier,
                  builder: (_, bool isPlaying, __) {
                    return _SongControlButton(
                      icon: isPlaying ? Icons.pause : Icons.play_arrow,
                      onPressed: () => songControlsBloc.add(const TogglePlayPauseEvent()),
                    );
                  },
                ),
                const SizedBox(width: 3),
                _SongControlButton(
                  icon: Icons.skip_next,
                  onPressed: () => songControlsBloc.add(const NextSongEvent()),
                ),
                const SizedBox(width: 3),
                _SongControlButton(
                  icon: Icons.repeat,
                  onPressed: () => userPreferencesCubit.toggleRepeat(),
                ),
              ],
            );
          },
        ),
      ],
    );
  }
}
