import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_footer_bloc/main_screen_body_footer_bloc.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_footer_bloc/main_screen_body_footer_event.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_footer_bloc/main_screen_body_footer_state.dart';
import 'package:frontend/shared/blocs/user_preferences_cubit.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/design_system/image_design_system.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/extensions/build_context_extension.dart';
import 'package:frontend/shared/models/user_preferences.dart';
import 'package:frontend/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:frontend/shared/widgets/images/base_image.dart';
import 'package:frontend/shared/widgets/sliders/base_slider.dart';
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

          return BlocBuilder<MainScreenBodyFooterBloc, MainScreenBodyFooterState>(
            builder: (context, mainScreenBodyFooterState) {
              return Row(
                children: [
                  if (showSideWidgets) _SongInformation(mainScreenBodyFooterState, width: sideWidgetWidths),
                  _SongControls(mainScreenBodyFooterState),
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
  final MainScreenBodyFooterState mainScreenBodyFooterState;
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
            svgPath: mainScreenBodyFooterState.loadedSong == null ? ImageDesignSystem.logo : null,
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
                Text(
                  mainScreenBodyFooterState.loadedSong?.$1.artist ?? '',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodySmall,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

final class _SongControls extends StatefulWidget {
  final MainScreenBodyFooterState mainScreenBodyFooterState;

  const _SongControls(this.mainScreenBodyFooterState);

  @override
  State<_SongControls> createState() => _SongControlsState();
}

class _SongControlsState extends State<_SongControls> with PlayerStateMixin {
  MainScreenBodyFooterState get _mainScreenBodyFooterState => widget.mainScreenBodyFooterState;

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
  void didUpdateWidget(covariant _SongControls oldWidget) {
    usePlayer(_mainScreenBodyFooterState.player);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void onPositionChanged(Duration position) {
    _songPositionNotifier.value = position.inSeconds.toDouble();
  }

  @override
  void onStatusChanged(PlayerStatus status) {
    _isPlayingNotifier.value = status == PlayerStatus.playing ? true : false;
  }
  // coverage:ignore-end

  @override
  Widget build(BuildContext context) {
    final userPreferencesCubit = BlocProvider.of<UserPreferencesCubit>(context);

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
                onChanged: (value) => BlocProvider.of<MainScreenBodyFooterBloc>(context).add(
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
                    onPressed: () => throw UnimplementedError(), // TODO
                  ),
                  const SizedBox(width: 1),
                  ValueListenableBuilder(
                    valueListenable: _isPlayingNotifier,
                    builder: (_, bool isPlaying, __) {
                      return _Button(
                        icon: isPlaying ? Icons.pause : Icons.play_arrow,
                        onPressed: () => BlocProvider.of<MainScreenBodyFooterBloc>(context)..add(const TogglePlayPauseEvent()),
                      );
                    },
                  ),
                  const SizedBox(width: 1),
                  _Button(
                    icon: Icons.skip_next,
                    onPressed: () => throw UnimplementedError(), // TODO
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
  final MainScreenBodyFooterState mainScreenBodyFooterState;
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
              _Button(
                icon: Icons.queue_music,
                onPressed: () => throw UnimplementedError(), // TODO
              ),
              const SizedBox(width: 5),
              BaseSlider(
                width: width >= 180 ? 180 : width,
                value: userPreferences.volume,
                max: 100,
                onChanged: (value) => BlocProvider.of<UserPreferencesCubit>(context).setVolume(value),
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
