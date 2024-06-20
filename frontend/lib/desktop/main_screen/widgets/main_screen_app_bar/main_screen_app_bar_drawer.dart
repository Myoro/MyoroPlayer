import 'package:flutter/material.dart';
import 'package:frontend/desktop/main_screen/enums/main_screen_app_bar_drawer_items_enum.dart';
import 'package:frontend/shared/controllers/base_drawer_controller.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:frontend/shared/widgets/scrollbars/vertical_scrollbar.dart';
import 'package:provider/provider.dart';

final class MainScreenAppBarDrawer extends StatelessWidget {
  const MainScreenAppBarDrawer._();

  static void show(BuildContext context) {
    context.read<BaseDrawerController>().openDrawer(
          drawerContent: const MainScreenAppBarDrawer._(),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VerticalScrollbar(
        children: MainScreenAppBarDrawerItemsEnum.values.map(
          (item) {
            return Column(
              children: [
                IconTextHoverButton(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  icon: item.icon,
                  iconSize: ImageSizeEnum.small.size,
                  text: item.text,
                  onTap: () => item.callback.call(context),
                ),
                if (item != MainScreenAppBarDrawerItemsEnum.values.last) const SizedBox(height: 5)
              ],
            );
          },
        ).toList(),
      ),
    );
  }
}
