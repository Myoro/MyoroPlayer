import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/shared/blocs/dark_mode_cubit.dart';
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
            svgSize: 40,
            svgColor: ColorDesignSystem.onBackground(context),
          ),
          const Spacer(),
          IconWithoutFeedbackButton(
            onTap: () => BlocProvider.of<DarkModeCubit>(context).toggle(),
            icon: Icons.sunny,
            iconSize: 40,
          )
        ],
      );
}
