import 'package:flutter/material.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/extensions/build_context_extension.dart';
import 'package:frontend/shared/extensions/text_style_extension.dart';
import 'package:frontend/shared/widgets/buttons/base_hover_button.dart';
import 'package:frontend/shared/widgets/headers/underline_header.dart';
import 'package:frontend/shared/widgets/scrollbars/vertical_scrollbar.dart';

final class MainScreenBodySongList extends StatelessWidget {
  const MainScreenBodySongList({super.key});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        children: [
          const UnderlineHeader(header: '<PLAYLIST NAME HERE>'),
          Expanded(
            child: VerticalScrollbar(
              children: List.generate(
                50,
                (index) {
                  return Padding(
                    padding: EdgeInsets.only(
                      top: 5,
                      bottom: index == 49 ? 5 : 0,
                    ),
                    child: const _Song(),
                  );
                },
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
    final TextTheme textTheme = context.textTheme;

    return BaseHoverButton(
      onTap: () {},
      padding: const EdgeInsets.symmetric(
        vertical: 3,
        horizontal: 5,
      ),
      builder: (hovered) {
        final Color contentColor = hovered
            ? ColorDesignSystem.background(context)
            : ColorDesignSystem.onBackground(context);
        final TextStyle bodyMedium = textTheme.bodyMedium!.withColor(contentColor);
        final TextStyle bodySmall = textTheme.bodySmall!.withColor(contentColor);

        return Row(
          children: [
            Icon(
              Icons.music_note,
              size: ImageSizeEnum.small.size + 10,
              color: contentColor,
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Song name qwijeeqijqeiorjqo ejwqoie jwqoie jqwoiej',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: bodyMedium,
                  ),
                  Text(
                    'SOng aritqe qwoune oiwje iwoqje oiqwje qwioej',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: bodySmall,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'aLijeqwje oqwiejqwiejwqoeijqoiejqwioje iqwje',
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: bodySmall,
              ),
            ),
            const SizedBox(width: 10),
            Text(
              '420:00',
              style: bodyMedium,
            ),
          ],
        );
      },
    );
  }
}
