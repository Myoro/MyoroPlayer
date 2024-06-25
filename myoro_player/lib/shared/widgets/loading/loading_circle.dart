import 'package:flutter/material.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';

class LoadingCircle extends StatelessWidget {
  const LoadingCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return CircularProgressIndicator(
      color: ColorDesignSystem.onBackground(context),
    );
  }
}
