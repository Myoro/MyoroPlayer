import 'package:flutter/material.dart';
import 'package:frontend/screens/main_screen/widgets/main_screen_app_bar/main_screen_app_bar_drawer.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/extensions/build_context_extension.dart';
import 'package:frontend/shared/widgets/app_bars/base_app_bar.dart';
import 'package:frontend/shared/widgets/buttons/icon_text_hover_button.dart';

final class MainScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainScreenAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return BaseAppBar(
      children: [
        const SizedBox(width: 10),
        Text(
          'MyoroPlayer',
          style: context.textTheme.titleLarge,
        ),
        const Spacer(),
        IconTextHoverButton(
          icon: Icons.menu,
          iconSize: ImageSizeEnum.small.size,
          // coverage:ignore-start
          onTap: () => MainScreenAppBarDrawer.show(context),
          // coverage:ignore-end
        ),
        const SizedBox(width: 3),
      ],
    );
  }
}
