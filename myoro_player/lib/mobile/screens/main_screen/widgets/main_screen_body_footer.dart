import 'package:flutter/material.dart';
import 'package:myoro_player/core/design_system/color_design_system.dart';
import 'package:myoro_player/core/design_system/image_design_system.dart';
import 'package:myoro_player/core/enums/image_size_enum.dart';
import 'package:myoro_player/core/extensions/duration_extension.dart';
import 'package:myoro_player/core/models/song.dart';
import 'package:myoro_player/core/widgets/buttons/no_feedback_button.dart';
import 'package:myoro_player/core/widgets/dividers/basic_divider.dart';
import 'package:myoro_player/core/widgets/images/base_image.dart';
import 'package:text_scroll/text_scroll.dart';

/// Footer that also doubles as a mini-screen
final class MainScreenBodyFooter extends StatelessWidget {
  const MainScreenBodyFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return _Footer(Song.mock);
  }
}

final class _Footer extends StatelessWidget {
  final Song song;

  const _Footer(this.song);

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final bodySmall = textTheme.bodySmall;
    final bodyMedium = textTheme.bodyMedium;

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 10,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Padding(
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
          ),
          const BasicDivider(
            direction: Axis.horizontal,
            padding: EdgeInsets.symmetric(
              vertical: 10,
            ),
          ),
          Wrap(
            spacing: 3,
            children: [
              _SongControlButton(
                Icons.shuffle,
                () => throw UnimplementedError(), // TODO
              ),
              _SongControlButton(
                Icons.skip_previous,
                () => throw UnimplementedError(), // TODO
              ),
              _SongControlButton(
                Icons.pause,
                () => throw UnimplementedError(), // TODO
              ),
              _SongControlButton(
                Icons.skip_next,
                () => throw UnimplementedError(), // TODO
              ),
              _SongControlButton(
                Icons.repeat,
                () => throw UnimplementedError(), // TODO
              ),
            ],
          ),
        ],
      ),
    );
  }
}

final class _SongControlButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback onPressed;

  const _SongControlButton(this.icon, this.onPressed);

  @override
  Widget build(BuildContext context) {
    return NoFeedbackButton(
      onTap: onPressed,
      child: Icon(
        icon,
        size: ImageSizeEnum.small.size + 10,
        color: ColorDesignSystem.onBackground(context),
      ),
    );
  }
}
