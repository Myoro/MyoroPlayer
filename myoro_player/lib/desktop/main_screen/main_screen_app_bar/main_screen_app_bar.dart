import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/blocs/dark_mode_cubit.dart';
import 'package:myoro_player/design_system/color_design_system.dart';
import 'package:myoro_player/design_system/svg_design_system.dart';
import 'package:myoro_player/widget_library/app_bars/base_app_bar.dart';
import 'package:myoro_player/widget_library/buttons/icon_without_feedback_button.dart';
import 'package:myoro_player/widget_library/icons/base_svg.dart';

class MainScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainScreenAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => BaseAppBar(
        children: [
          BaseSvg(
            svgPath: SvgDesignSystem.logo,
            svgSize: 40,
            svgColor: ColorDesignSystem.onBackground(context),
          ),
          const Spacer(),
          IconWithoutFeedbackButton(
            onTap: () => BlocProvider.of<DarkModeCubit>(context).toggle(),
            icon: Icons.sunny,
            iconSize: 40,
          ),
        ],
      );
}
