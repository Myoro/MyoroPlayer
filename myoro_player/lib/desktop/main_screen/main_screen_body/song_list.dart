import 'package:flutter/material.dart';
import 'package:myoro_player/design_system/color_design_system.dart';
import 'package:myoro_player/design_system/decoration_design_system.dart';
import 'package:myoro_player/design_system/svg_design_system.dart';
import 'package:myoro_player/enums/divider_type_enum.dart';
import 'package:myoro_player/widgets/dividers/basic_divider.dart';
import 'package:myoro_player/widgets/icons/base_svg.dart';

class SongList extends StatelessWidget {
  const SongList({super.key});

  @override
  Widget build(BuildContext context) => Expanded(
        child: Padding(
          /// Match offset applied in [PlaylistSideBar]
          padding: const EdgeInsets.only(left: 15),
          child: Column(
            children: [
              Padding(
                /// Offset scrollbar offset [Padding] below
                padding: const EdgeInsets.only(right: 15),
                child: Column(
                  children: [
                    Text(
                      '<PLAYLIST NAME HERE>',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const SizedBox(height: 5),
                    const BasicDivider(
                      dividerType: DividerTypeEnum.horizontal,
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    // Offset scrollbar
                    padding: const EdgeInsets.only(right: 15),
                    child: Column(
                      children: [
                        for (int i = 0; i < 50; i++) ...[
                          const _Song(),
                          const SizedBox(height: 5),
                        ],
                      ],
                    ),
                  ),
                ),
              ),
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
  final ValueNotifier<bool> _hovered = ValueNotifier<bool>(false);

  @override
  void dispose() {
    _hovered.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) => InkWell(
          hoverColor: ColorDesignSystem.transparent,
          splashColor: ColorDesignSystem.transparent,
          highlightColor: ColorDesignSystem.transparent,
          onTap: () {}, // TODO
          onHover: (value) => _hovered.value = value,
          child: ValueListenableBuilder(
            valueListenable: _hovered,
            builder: (context, hovered, child) {
              final TextTheme textTheme = Theme.of(context).textTheme;
              final Color iconAndTextColor = !hovered ? ColorDesignSystem.onBackground(context) : ColorDesignSystem.background(context);
              final TextStyle bodyMedium = textTheme.bodyMedium!.copyWith(color: iconAndTextColor);
              final TextStyle bodySmall = textTheme.bodySmall!.copyWith(color: iconAndTextColor);

              return Container(
                height: 60,
                decoration: BoxDecoration(
                  color: !hovered ? ColorDesignSystem.transparent : ColorDesignSystem.onBackground(context),
                  borderRadius: DecorationDesignSystem.borderRadius,
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      BaseSvg(
                        svgPath: SvgDesignSystem.logo,
                        svgSize: 30,
                        svgColor: iconAndTextColor,
                      ),

                      /// Adjustments when resizing [PlaylistSideBar]
                      if (constraints.maxWidth > 140) ...[
                        const SizedBox(width: 5),
                        Expanded(
                          child: Column(
                            children: [
                              Text(
                                'Song nameqowneijqweroiweJrojwerwieojr qwiojeqwoiejqwoie',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: bodyMedium,
                              ),
                              Text(
                                'Ski Mask the Slump God qwiejqweoirjwerouiejhroitr hreo reiotj ewopirjhwe opuirhj',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                                style: bodySmall,
                              ),
                            ],
                          ),
                        ),
                      ],
                      const SizedBox(width: 5),
                      Expanded(
                        child: Text(
                          'Album name her ekqwjneroiuerghpo wjheoçri jweoirj qweopjrewo irweropji',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: bodySmall,
                        ),
                      ),
                      const SizedBox(width: 5),
                      Text(
                        '123:45:56',
                        style: bodyMedium,
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
        ),
      );
}
