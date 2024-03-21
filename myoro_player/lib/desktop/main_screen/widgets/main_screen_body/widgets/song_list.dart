import 'package:flutter/material.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/design_system/icon_design_system.dart';
import 'package:myoro_player/shared/enums/divider_type_enum.dart';
import 'package:myoro_player/shared/widgets/base_svg.dart';
import 'package:myoro_player/shared/widgets/dividers/basic_divider.dart';

class SongList extends StatelessWidget {
  const SongList({super.key});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Padding(
          padding: const EdgeInsets.only(
            top: 4.5,
            right: 15,
          ),
          child: Column(
            children: [
              Text(
                '<PLAYLIST NAME HERE>',
                style: Theme.of(context).textTheme.titleSmall,
              ),
              const BasicDivider(dividerTypeEnum: DividerTypeEnum.horizontal),
              const _Song(),
            ],
          ),
        ),
      );
}

class _Song extends StatefulWidget {
  const _Song();

  @override
  State<_Song> createState() => _SongState();
}

class _SongState extends State<_Song> {
  @override
  Widget build(BuildContext context) => Row(
        children: [
          BaseSvg(
            svgPath: IconDesignSystem.logo,
            svgSize: 30,
            svgColor: ColorDesignSystem.onBackground(context),
          ),
          Column(
            children: [
              Text(
                'Song nameqwoiejqwoiejqwoeij qwoiejqwoiejq woiej',
                style: Theme.of(context).textTheme.bodyMedium,
              ),
              Text(
                'Artist qwiejqwoiejqwoiej qweqiwejqoiwejqeoiq',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ],
          ),
          Text(
            'Album qiowejqoiejwqejqwoie jwqoiej wqoie jwqoiej wqoiej',
            style: Theme.of(context).textTheme.bodySmall,
          ),
          Text(
            '12:00',
            style: Theme.of(context).textTheme.bodyMedium,
          ),
        ],
      );
}
