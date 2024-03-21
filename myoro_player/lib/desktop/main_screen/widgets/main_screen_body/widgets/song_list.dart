import 'package:flutter/material.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/design_system/decoration_design_system.dart';
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
            top: 5,
            right: 15,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15),
                child: Column(
                  children: [
                    Text(
                      '<PLAYLIST NAME HERE>',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                    const BasicDivider(
                      dividerTypeEnum: DividerTypeEnum.horizontal,
                    ),
                    const Row(
                      children: [
                        _TitleColumn(
                          text: 'Cover',
                        ),
                        SizedBox(width: 14),
                        _TitleColumn(
                          text: 'Song name and/or artist',
                          expanded: true,
                          textAlign: TextAlign.left,
                        ),
                        SizedBox(width: 10),
                        _TitleColumn(
                          text: 'Album',
                          expanded: true,
                        ),
                        SizedBox(width: 10),
                        _TitleColumn(
                          text: 'Length',
                          width: 45,
                        ),
                        SizedBox(width: 5),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 5),
              Expanded(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15), // Offset scrollbar
                    child: Column(
                      children: [
                        for (int i = 0; i < 50; i++) ...[
                          const _Song(),
                          const SizedBox(height: 10),
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
  Widget build(BuildContext context) => InkWell(
        hoverColor: ColorDesignSystem.transparent,
        splashColor: ColorDesignSystem.transparent,
        highlightColor: ColorDesignSystem.transparent,
        onTap: () {}, // TODO
        onHover: (value) => _hovered.value = value,
        child: ValueListenableBuilder(
            valueListenable: _hovered,
            builder: (context, hovered, child) {
              final Color onBackground = !hovered
                  ? ColorDesignSystem.onBackground(context)
                  : ColorDesignSystem.background(context);

              return AnimatedContainer(
                duration: const Duration(milliseconds: 150),
                decoration: BoxDecoration(
                  color: !hovered
                      ? ColorDesignSystem.transparent
                      : ColorDesignSystem.onBackground(context),
                  borderRadius: DecorationDesignSystem.borderRadius,
                ),
                child: Padding(
                  padding: const EdgeInsets.all(5),
                  child: Row(
                    children: [
                      BaseSvg(
                        svgPath: IconDesignSystem.logo,
                        svgSize: 30,
                        svgColor: onBackground,
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Song nameqwoiejqwoiejqwoeij qwoiejqwoiejq woiej',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyMedium!
                                  .copyWith(
                                    color: onBackground,
                                  ),
                            ),
                            Text(
                              'Artist qwiejqwoiejqwoiej qweqiwejqoiwejqeoiq',
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: Theme.of(context)
                                  .textTheme
                                  .bodySmall!
                                  .copyWith(color: onBackground),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 10),
                      Expanded(
                        child: Text(
                          'Album qiowejqoiejwqejqwoie jwqoiej wqoie jwqoiej wqoiej',
                          style:
                              Theme.of(context).textTheme.bodySmall!.copyWith(
                                    color: onBackground,
                                  ),
                          textAlign: TextAlign.center,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      const SizedBox(width: 10),
                      SizedBox(
                        width: 45,
                        child: Text(
                          '12:00',
                          textAlign: TextAlign.center,
                          style:
                              Theme.of(context).textTheme.bodyMedium!.copyWith(
                                    color: onBackground,
                                  ),
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
      );
}

class _TitleColumn extends StatelessWidget {
  final String text;
  final bool expanded;
  final TextAlign? textAlign;
  final double? width;

  const _TitleColumn({
    required this.text,
    this.expanded = false,
    this.textAlign = TextAlign.center,
    this.width,
  });

  @override
  Widget build(BuildContext context) => !expanded
      ? SizedBox(width: width, child: _widget(context))
      : Expanded(child: _widget(context));

  Widget _widget(BuildContext context) => Tooltip(
        message: text,
        child: Text(
          text,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          textAlign: textAlign,
          style: Theme.of(context).textTheme.bodySmall,
        ),
      );
}
