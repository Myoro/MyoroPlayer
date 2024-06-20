import 'package:flutter/material.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/design_system/typography_design_system.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/extensions/text_style_extension.dart';
import 'package:frontend/shared/widgets/buttons/base_hover_button.dart';
import 'package:frontend/shared/widgets/scrollbars/vertical_scrollbar.dart';
import 'package:frontend/shared/widgets/titles/underline_title.dart';

final class MainScreenBodySongList extends StatefulWidget {
  const MainScreenBodySongList({super.key});

  @override
  State<MainScreenBodySongList> createState() => _MainScreenBodySongListState();
}

class _MainScreenBodySongListState extends State<MainScreenBodySongList> {
  final _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const UnderlineTitle(text: '<Playlist Name>'),
          Expanded(
            child: VerticalScrollbar(
              children: [
                for (int i = 0; i < 50; i++) ...[
                  const SizedBox(height: 5),
                  const _Song(),
                  if (i == 49) const SizedBox(height: 5),
                ],
              ],
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
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Songqowuiejqwoiejqwoiejqwoiejqoiejwqeioj title',
                    style: bodyMedium,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  Text(
                    'Song aqwpiejqwoiejqwoiejqwoiejqwoiejrtist',
                    style: bodySmall,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                ],
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Text(
                'Song albuqjweoiqwjeioqjeoqiwjeoqiwjeioqwem',
                style: bodySmall,
                textAlign: TextAlign.center,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ),
            const SizedBox(width: 10),
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
