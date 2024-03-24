import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/blocs/dark_mode_cubit.dart';
import 'package:myoro_player/design_system/color_design_system.dart';
import 'package:myoro_player/design_system/svg_design_system.dart';
import 'package:myoro_player/helpers/build_context_helper.dart';
import 'package:myoro_player/widgets/app_bars/base_app_bar.dart';
import 'package:myoro_player/widgets/buttons/icon_without_feedback_button.dart';
import 'package:myoro_player/widgets/icons/base_svg.dart';
import 'package:myoro_player/widgets/shortcuts/actions/new_playlist_shortcut_action.dart';

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
            onTap: () => NewPlaylistAction.newPlaylist(), // TODO
            tooltip: 'Open an existing playlist/folder\n\nCtrl + O',
            icon: Icons.add,
            iconSize: 40,
          ),
          const SizedBox(width: 5),
          IconWithoutFeedbackButton(
            onTap: () {},
            tooltip: 'Create a new playlist/folder\n\nCtrl + N',
            icon: Icons.folder_open,
            iconSize: 40,
          ),
          const SizedBox(width: 5),
          IconWithoutFeedbackButton(
            onTap: () => BlocProvider.of<DarkModeCubit>(context).toggle(),
            tooltip: 'Switch to ${context.isDarkMode ? 'light' : 'dark'} mode',
            icon: Icons.sunny,
            iconSize: 40,
          ),
        ],
      );
}
