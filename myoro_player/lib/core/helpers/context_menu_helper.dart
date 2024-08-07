import 'package:flutter/material.dart';
import 'package:myoro_player/core/design_system/color_design_system.dart';
import 'package:myoro_player/core/design_system/decoration_design_system.dart';
import 'package:myoro_player/core/enums/image_size_enum.dart';
import 'package:myoro_player/core/extensions/build_context_extension.dart';
import 'package:myoro_player/core/models/menu_item.dart';

/// Used whenever a [showMenu] is required
final class ContextMenuHelper {
  static void show(
    BuildContext context,
    TapDownDetails details, {
    required double width,
    required List<MenuItem> items,
  }) {
    final Color onBackground = ColorDesignSystem.onBackground(context);

    showMenu(
      context: context,
      shape: RoundedRectangleBorder(
        borderRadius: DecorationDesignSystem.borderRadius,
        side: BorderSide(
          width: 2,
          color: onBackground,
        ),
      ),
      constraints: BoxConstraints(
        minWidth: width,
        maxWidth: width,
      ),
      position: RelativeRect.fromLTRB(
        details.globalPosition.dx,
        details.globalPosition.dy,
        MediaQuery.of(context).size.width,
        0,
      ),
      items: items.map<PopupMenuItem>(
        (item) {
          return PopupMenuItem(
            value: item.text,
            onTap: () => item.onTap.call(),
            child: Wrap(
              spacing: 10,
              crossAxisAlignment: WrapCrossAlignment.center,
              children: [
                Icon(
                  item.icon,
                  size: ImageSizeEnum.small.size,
                  color: onBackground,
                ),
                Text(
                  item.text,
                  style: context.textTheme.bodyMedium,
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}
