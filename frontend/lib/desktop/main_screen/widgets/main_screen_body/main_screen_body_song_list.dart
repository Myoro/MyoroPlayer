import 'package:flutter/material.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/design_system/typography_design_system.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/extensions/text_style_extension.dart';
import 'package:frontend/shared/widgets/buttons/base_hover_button.dart';
import 'package:frontend/shared/widgets/titles/underline_title.dart';

final class MainScreenBodySongList extends StatelessWidget {
  const MainScreenBodySongList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const UnderlineTitle(text: '<Playlist Name>'),
          Expanded(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                ),
                child: Column(
                  children: [
                    for (int i = 0; i < 50; i++) ...[
                      const SizedBox(height: 5),
                      const _Song(),
                      if (i == 49) const SizedBox(height: 5),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

final class _Song extends StatelessWidget {
  const _Song();

  @override
  Widget build(BuildContext context) {
    return BaseHoverButton(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 5,
      ),
      onTap: () => print('TODO'),
      builder: (hovered) {
        final contentColor = hovered ? ColorDesignSystem.background(context) : ColorDesignSystem.onBackground(context);
        final bodyMedium = TypographyDesignSystem.bodyMedium.withColor(contentColor);
        final bodySmall = TypographyDesignSystem.bodySmall.withColor(contentColor);

        return Row(
          children: [
            Icon(
              Icons.music_note,
              size: ImageSizeEnum.small.size,
              color: contentColor,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Song title',
                  style: bodyMedium,
                ),
                Text(
                  'Song artist',
                  style: bodySmall,
                ),
              ],
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Song album',
                style: bodySmall,
                textAlign: TextAlign.center,
              ),
            ),
            Text(
              '420:00',
              style: bodyMedium,
              textAlign: TextAlign.center,
            ),
          ],
        );
      },
    );
  }
}
