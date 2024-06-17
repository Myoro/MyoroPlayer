import 'package:flutter/material.dart';
import 'package:frontend/desktop/main_screen/widgets/main_screen_body/main_screen_body_playlist_side_bar.dart';
import 'package:frontend/shared/widgets/bodies/base_body.dart';

final class MainScreenBody extends StatelessWidget {
  const MainScreenBody({super.key});

  @override
  Widget build(BuildContext context) {
    return BaseBody(
      child: Row(
        children: [
          const MainScreenBodyPlaylistSideBar(),
          Expanded(
            child: Container(
              color: Colors.blue.withOpacity(0.6),
            ),
          ),
        ],
      ),
    );
  }
}
