import 'package:flutter/material.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/design_system/decoration_design_system.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/models/context_menu_item.dart';

/// Used whenever a [showMenu] is required
final class ContextMenuHelper {
  static void show(
    BuildContext context,
    TapDownDetails details, {
    required double width,
    required List<ContextMenuItem> items,
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
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
          );
        },
      ).toList(),
    );
  }
}
