import 'package:flutter/material.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/design_system/decoration_design_system.dart';
import 'package:myoro_player/shared/enums/image_size_enum.dart';
import 'package:myoro_player/shared/extensions/build_context_extension.dart';
import 'package:myoro_player/shared/widgets/buttons/icon_text_hover_button.dart';

final class BaseDrawer extends StatelessWidget {
  final String? title;
  final Widget child;

  const BaseDrawer({
    super.key,
    this.title,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconTextHoverButton(
            icon: Icons.arrow_right,
            iconSize: ImageSizeEnum.small.size,
            bordered: true,
            onTap: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 10),
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
        ],
      ),
    );
  }
}
