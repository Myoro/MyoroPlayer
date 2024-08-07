import 'package:flutter/material.dart';
import 'package:myoro_player/shared/enums/main_screen_app_bar_options_drawer_items_enum.dart';
import 'package:myoro_player/core/controllers/base_drawer_controller.dart';
import 'package:myoro_player/core/enums/image_size_enum.dart';
import 'package:myoro_player/core/widgets/buttons/icon_text_hover_button.dart';
import 'package:myoro_player/core/widgets/drawers/base_drawer.dart';
import 'package:myoro_player/core/widgets/scrollbars/vertical_scroll_list.dart';
import 'package:provider/provider.dart';

final class MainScreenAppBarOptionsDrawer extends StatelessWidget {
  const MainScreenAppBarOptionsDrawer._();

  static void show(BuildContext context) {
    context.read<BaseDrawerController>().openEndDrawer(
          drawer: const BaseDrawer(
            child: MainScreenAppBarOptionsDrawer._(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VerticalScrollList(
        children: MainScreenAppBarOptionsDrawerItemsEnum.values.map(
          (value) {
            return Padding(
              padding: EdgeInsets.only(
                top: 5,
                bottom: value != MainScreenAppBarOptionsDrawerItemsEnum.values.last ? 5 : 0,
              ),
              child: IconTextHoverButton(
                icon: value.icon,
                iconSize: ImageSizeEnum.small.size,
                text: value.text,
                padding: const EdgeInsets.all(5),
                onTap: () {
                  value.callback.call(context);
                  Navigator.of(context).pop();
                },
              ),
            );
          },
        ).toList(),
      ),
    );
  }
}
