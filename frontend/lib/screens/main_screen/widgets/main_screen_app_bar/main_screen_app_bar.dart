import 'package:flutter/material.dart';
import 'package:frontend/screens/main_screen/widgets/main_screen_app_bar/main_screen_app_bar_drawer.dart';
import 'package:frontend/shared/design_system/image_design_system.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/widgets/app_bars/base_app_bar.dart';
import 'package:frontend/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:frontend/shared/widgets/images/base_image.dart';

final class MainScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainScreenAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BaseAppBar(
      children: [
        Padding(
          padding: const EdgeInsets.only(
            left: 5,
          ),
          child: BaseImage(
            svgPath: ImageDesignSystem.logo,
            size: ImageSizeEnum.small.size + 10,
          ),
        ),
        const Spacer(),
        IconTextHoverButton(
          icon: Icons.menu,
          iconSize: ImageSizeEnum.small.size,
          onTap: () => MainScreenAppBarDrawer.show(context),
        ),
      ],
    );
  }
}
