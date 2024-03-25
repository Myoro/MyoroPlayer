import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:myoro_player/blocs/playlist_side_bar_cubit.dart';
import 'package:myoro_player/desktop/main_screen/main_screen_body/playlist_side_bar.dart';
import 'package:myoro_player/desktop/main_screen/main_screen_body/song_list.dart';
import 'package:myoro_player/widgets/bodies/base_body.dart';

class MainScreenBody extends StatelessWidget {
  const MainScreenBody({super.key});

  @override
  Widget build(BuildContext context) => BaseBody(
        child: Row(
          children: [
            BlocProvider(
              create: (context) => PlaylistSideBarCubit()..getPlaylists(),
              child: const PlaylistSideBar(),
            ),
            const SongList(),
          ],
        ),
      );
}
