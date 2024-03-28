import 'package:flutter/material.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';

class BaseAppBar extends StatelessWidget implements PreferredSizeWidget {
  final List<Widget> children;

  const BaseAppBar({super.key, required this.children});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        surfaceTintColor: ColorDesignSystem.transparent,
        title: Row(
          children: children,
        ),
      );
}
