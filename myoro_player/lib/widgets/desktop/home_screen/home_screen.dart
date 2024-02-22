import 'package:flutter/material.dart';
import 'package:myoro_player/widgets/desktop/home_screen/app_bar/home_screen_app_bar.dart';
import 'package:myoro_player/widgets/desktop/home_screen/body/home_screen_body.dart';

/// Starting screen of the application
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) => const Scaffold(
        appBar: HomeScreenAppBar(),
        body: HomeScreenBody(),
      );
}
