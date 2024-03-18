import 'package:flutter/material.dart';
import 'package:myoro_player/widgets/app_bars/main_screen_app_bar.dart';
import 'package:myoro_player/widgets/bodies/main_screen_body.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        appBar: MainScreenAppBar(),
        body: MainScreenBody(),
      );
}
