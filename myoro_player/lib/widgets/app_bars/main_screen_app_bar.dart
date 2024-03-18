import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/blocs/dark_mode_cubit.dart';
import 'package:myoro_player/widgets/app_bars/base_app_bar.dart';
import 'package:myoro_player/widgets/buttons/icon_button_without_feedback.dart';

class MainScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const MainScreenAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => BaseAppBar(
        children: [
          Text(
            'MyoroPlayer',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const Spacer(),
          IconButtonWithoutFeedback(
            onTap: () =>
                BlocProvider.of<DarkModeCubit>(context).toggle(context),
            icon: Icons.sunny,
            iconSize: 40,
          ),
        ],
      );
}
