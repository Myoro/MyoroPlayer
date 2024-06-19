import 'package:flutter/material.dart';
import 'package:frontend/shared/controllers/base_drawer_controller.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/design_system/decoration_design_system.dart';
import 'package:frontend/shared/design_system/typography_design_system.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:provider/provider.dart';

/// The only drawer widget of MyoroPlayer
///
/// Every drawer must have a static function, i.e.:
/// ``` dart
/// final class FooDrawer extends StatelessWidget {
///   const FooDrawer({super.key});
///
///   static void show(BuildContext context) {
///     context.read<BaseDrawerController>().openDrawer(
///       FooDrawer(),
///     );
///   }
///
///   @override
///   Widget build(BuildContext context) => ...;
/// }
/// ```
final class BaseDrawer extends StatelessWidget {
  final String? title;
  final Widget child;

  const BaseDrawer({
    this.title,
    required this.child,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Drawer(
        shape: RoundedRectangleBorder(
          borderRadius: DecorationDesignSystem.borderRadius,
          side: BorderSide(
            width: 2,
            color: ColorDesignSystem.onBackground(context),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            children: [
              Row(
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: TypographyDesignSystem.titleSmall,
                    ),
                  const Spacer(),
                  IconTextHoverButton(
                    icon: Icons.close,
                    iconSize: ImageSizeEnum.small.size,
                    onTap: () => context.read<BaseDrawerController>().closeDrawer(),
                  ),
                ],
              ),
              child,
            ],
          ),
        ),
      ),
    );
  }
}
