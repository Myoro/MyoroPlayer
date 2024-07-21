import 'package:flutter/material.dart';
import 'package:myoro_player/core/design_system/color_design_system.dart';
import 'package:myoro_player/core/design_system/decoration_design_system.dart';
import 'package:myoro_player/core/enums/image_size_enum.dart';
import 'package:myoro_player/core/extensions/build_context_extension.dart';
import 'package:myoro_player/core/widgets/buttons/icon_text_hover_button.dart';

final class BaseDrawer extends StatelessWidget {
  final String? title;
  final Widget child;
  final bool isEndDrawer;

  const BaseDrawer({
    super.key,
    this.title,
    required this.child,
    this.isEndDrawer = true,
  });

  @override
  Widget build(BuildContext context) {
    final closeButton = IconTextHoverButton(
      icon: isEndDrawer ? Icons.arrow_right : Icons.arrow_left,
      iconSize: ImageSizeEnum.small.size,
      bordered: true,
      onTap: () => Navigator.of(context).pop(),
    );

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(10),
        child: Row(
          mainAxisAlignment: isEndDrawer ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            if (isEndDrawer) ...[
              closeButton,
              const SizedBox(width: 10),
            ],
            Drawer(
              width: 250,
              shape: RoundedRectangleBorder(
                borderRadius: DecorationDesignSystem.borderRadius,
                side: BorderSide(
                  width: 2,
                  color: ColorDesignSystem.onBackground(context),
                ),
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Column(
                  children: [
                    if (title != null) ...[
                      Text(
                        title!,
                        style: context.textTheme.titleLarge,
                      ),
                      const SizedBox(height: 2),
                    ],
                    child,
                  ],
                ),
              ),
            ),
            if (!isEndDrawer) ...[
              const SizedBox(width: 10),
              closeButton,
            ],
          ],
        ),
      ),
    );
  }
}
