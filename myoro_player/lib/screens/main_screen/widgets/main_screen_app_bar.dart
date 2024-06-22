import 'package:flutter/material.dart';
import 'package:myoro_player/shared/enums/image_size_enum.dart';
import 'package:myoro_player/shared/extensions/build_context_extension.dart';
import 'package:myoro_player/shared/widgets/app_bars/base_app_bar.dart';
import 'package:myoro_player/shared/widgets/buttons/icon_text_hover_button.dart';

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
          onTap: () {},
        ),
        const SizedBox(width: 3),
      ],
    );
  }
}
