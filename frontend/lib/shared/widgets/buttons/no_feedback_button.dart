import 'package:flutter/material.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';

final class NoFeedbackButton extends StatelessWidget {
  final VoidCallback onTap;
  final Widget child;

  const NoFeedbackButton({
    super.key,
    required this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      hoverColor: ColorDesignSystem.transparent,
      splashColor: ColorDesignSystem.transparent,
      highlightColor: ColorDesignSystem.transparent,
      onTap: () => onTap.call(),
      child: child,
    );
  }
}
