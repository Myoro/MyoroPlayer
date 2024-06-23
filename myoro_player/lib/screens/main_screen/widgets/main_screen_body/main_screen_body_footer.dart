import 'package:flutter/material.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/enums/image_size_enum.dart';
import 'package:myoro_player/shared/extensions/build_context_extension.dart';
import 'package:myoro_player/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:myoro_player/shared/widgets/sliders/base_slider.dart';

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
          final bool showSideWidgets = constraints.maxWidth >= 650;
          final sideWidgetWidths = constraints.maxWidth / 3;

          return Row(
            children: [
              if (showSideWidgets) _SongInformation(width: sideWidgetWidths),
              const _SongControls(),
              if (showSideWidgets) _MiscControls(width: sideWidgetWidths),
            ],
          );
        },
      ),
    );
  }
}

final class _SongInformation extends StatelessWidget {
  final double width;

  const _SongInformation({required this.width});

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = context.textTheme;

    return SizedBox(
      width: width,
      child: Row(
        children: [
          Icon(
            Icons.music_note,
            size: ImageSizeEnum.small.size + 10,
            color: ColorDesignSystem.onBackground(context),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Song qwenqwi j wioje qwioje qiwej',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: textTheme.bodyMedium,
                ),
                Text(
                  'asd owqo jwqeoiqwewiqjeoiqwjeqwoij',
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

final class _SongControls extends StatelessWidget {
  const _SongControls();

  @override
  Widget build(BuildContext context) {
    return const Expanded(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          BaseSlider(width: 180),
          SizedBox(height: 1),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _Button(icon: Icons.shuffle),
              _Button(icon: Icons.skip_previous),
              _Button(icon: Icons.pause),
              _Button(icon: Icons.skip_next),
              _Button(icon: Icons.repeat),
            ],
          ),
        ],
      ),
    );
  }
}

final class _MiscControls extends StatelessWidget {
  final double width;

  const _MiscControls({required this.width});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          const _Button(icon: Icons.queue_music),
          BaseSlider(width: width >= 180 ? 180 : width),
        ],
      ),
    );
  }
}

final class _Button extends StatelessWidget {
  final IconData icon;

  const _Button({required this.icon});

  @override
  Widget build(BuildContext context) {
    return IconTextHoverButton(
      icon: icon,
      iconSize: ImageSizeEnum.small.size,
      onTap: () {},
    );
  }
}
