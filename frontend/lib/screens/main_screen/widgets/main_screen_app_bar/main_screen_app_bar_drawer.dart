import 'package:flutter/material.dart';
import 'package:frontend/screens/main_screen/enums/main_screen_app_bar_drawer_items_enum.dart';
import 'package:frontend/shared/controllers/base_drawer_controller.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:frontend/shared/widgets/drawers/base_drawer.dart';
import 'package:frontend/shared/widgets/scrollbars/vertical_scrollbar.dart';
import 'package:provider/provider.dart';

final class MainScreenAppBarDrawer extends StatelessWidget {
  const MainScreenAppBarDrawer._();

  static void show(BuildContext context) {
    context.read<BaseDrawerController>().openDrawer(
          drawer: const BaseDrawer(
            child: MainScreenAppBarDrawer._(),
          ),
        );
  }

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: VerticalScrollbar(
        children: MainScreenAppBarDrawerItemsEnum.values.map(
          (value) {
            return Padding(
              padding: EdgeInsets.only(
                top: 5,
                bottom: value != MainScreenAppBarDrawerItemsEnum.values.last ? 5 : 0,
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
