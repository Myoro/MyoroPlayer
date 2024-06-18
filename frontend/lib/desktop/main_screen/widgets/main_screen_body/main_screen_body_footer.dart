import 'package:flutter/material.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/design_system/typography_design_system.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:frontend/shared/widgets/sliders/base_slider.dart';

final class MainScreenBodyFooter extends StatelessWidget {
  const MainScreenBodyFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: SizedBox(
        height: 65,
        child: LayoutBuilder(
          builder: (context, constraints) {
            final double maxWidth = constraints.maxWidth;

            return Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const _SongInformation(),
                if (maxWidth >= 550) ...[
                  const SizedBox(width: 10),
                  const _SongControls(),
                ],
                if (maxWidth >= 400) ...[
                  const SizedBox(width: 10),
                  const _MiscControls(),
                ],
              ],
            );
          },
        ),
      ),
    );
  }
}

final class _SongInformation extends StatelessWidget {
  const _SongInformation();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        children: [
          Icon(
            Icons.music_note,
            size: ImageSizeEnum.small.size,
            color: ColorDesignSystem.onBackground(context),
          ),
          const SizedBox(width: 5),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '<Song name here>qwiejqwoiejqwoiej',
                  style: TypographyDesignSystem.bodyMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '<Song artist her> iqwjeqoijeqoiej',
                  style: TypographyDesignSystem.bodySmall,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
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
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const BaseSlider(),
        Row(
          children: [
            IconTextHoverButton(
              icon: Icons.shuffle,
              iconSize: ImageSizeEnum.small.size,
              onTap: () {},
            ),
            const SizedBox(width: 3),
            IconTextHoverButton(
              icon: Icons.skip_previous,
              iconSize: ImageSizeEnum.small.size,
              onTap: () {},
            ),
            const SizedBox(width: 3),
            IconTextHoverButton(
              icon: Icons.pause,
              iconSize: ImageSizeEnum.small.size,
              onTap: () {},
            ),
            const SizedBox(width: 3),
            IconTextHoverButton(
              icon: Icons.skip_next,
              iconSize: ImageSizeEnum.small.size,
              onTap: () {},
            ),
            const SizedBox(width: 3),
            IconTextHoverButton(
              icon: Icons.repeat,
              iconSize: ImageSizeEnum.small.size,
              onTap: () {},
            ),
          ],
        ),
      ],
    );
  }
}

final class _MiscControls extends StatelessWidget {
  const _MiscControls();

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconTextHoverButton(
            icon: Icons.queue_music,
            iconSize: ImageSizeEnum.small.size,
            onTap: () {},
          ),
          const BaseSlider(width: 150),
        ],
      ),
    );
  }
}
