import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/shared/blocs/dark_mode_cubit.dart';
import 'package:myoro_player/shared/helpers/build_context_helper.dart';
import 'package:myoro_player/shared/widgets/base_app_bar.dart';
import 'package:myoro_player/shared/widgets/base_svg.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/design_system/icon_design_system.dart';
import 'package:myoro_player/shared/widgets/buttons/icon_without_feedback_button.dart';

class MainScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainScreenAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => BaseAppBar(
        children: [
          BaseSvg(
            svgPath: IconDesignSystem.logo,
            svgSize: 30,
            svgColor: ColorDesignSystem.onBackground(context),
          ),
          const Spacer(),
          IconWithoutFeedbackButton(
            onTap: () => BlocProvider.of<DarkModeCubit>(context).toggle(),
            icon: Icons.add,
            iconSize: 40,
            tooltip: 'Add a new playlist',
          ),
          const SizedBox(width: 5),
          IconWithoutFeedbackButton(
            onTap: () => BlocProvider.of<DarkModeCubit>(context).toggle(),
            icon: Icons.folder_open,
            iconSize: 40,
            tooltip: 'Open a new playlist',
          ),
          const SizedBox(width: 5),
          IconWithoutFeedbackButton(
            onTap: () => BlocProvider.of<DarkModeCubit>(context).toggle(),
            icon: Icons.sunny,
            iconSize: 40,
            tooltip: 'Toggle ${context.isDarkMode ? 'light' : 'dark'} mode',
          ),
        ],
      );
}
