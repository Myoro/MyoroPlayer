import 'package:flutter/material.dart';
import 'package:myoro_player/mobile/main_screen/widgets/main_screen_app_bar.dart';
import 'package:myoro_player/mobile/main_screen/widgets/main_screen_body.dart';
import 'package:myoro_player/core/widgets/scaffolds/base_scaffold.dart';

final class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseScaffold(
      appBar: MainScreenAppBar(),
      body: MainScreenBody(),
    );
  }
}
