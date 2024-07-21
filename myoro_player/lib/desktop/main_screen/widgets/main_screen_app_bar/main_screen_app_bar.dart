import 'package:flutter/material.dart';
import 'package:myoro_player/shared/widgets/screens/main_screen/main_screen_app_bar_options_drawer.dart';
import 'package:myoro_player/core/design_system/image_design_system.dart';
import 'package:myoro_player/core/enums/image_size_enum.dart';
import 'package:myoro_player/core/widgets/app_bars/base_app_bar.dart';
import 'package:myoro_player/core/widgets/buttons/icon_text_hover_button.dart';
import 'package:myoro_player/core/widgets/images/base_image.dart';

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
          onTap: () => MainScreenAppBarOptionsDrawer.show(context),
        ),
      ],
    );
  }
}
