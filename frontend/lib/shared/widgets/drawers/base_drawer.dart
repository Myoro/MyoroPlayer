import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:frontend/shared/controllers/base_drawer_controller.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/design_system/decoration_design_system.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/extensions/build_context_extension.dart';
import 'package:frontend/shared/widgets/buttons/icon_text_hover_button.dart';

final class BaseDrawer extends StatelessWidget {
  final String? title;
  final bool showCloseButton;
  final Widget child;

  const BaseDrawer({
    super.key,
    this.title,
    this.showCloseButton = true,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Drawer(
        width: 250,
        shape: RoundedRectangleBorder(
          borderRadius: DecorationDesignSystem.borderRadius,
          side: BorderSide(
            width: 2,
            color: ColorDesignSystem.onBackground(context),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(5),
          child: Column(
            children: [
              Row(
                children: [
                  if (title != null)
                    Text(
                      title!,
                      style: context.textTheme.titleSmall,
                    ),
                  const Spacer(),
                  if (showCloseButton)
                    IconTextHoverButton(
                      key: const Key('BaseDrawer close button'),
                      icon: Icons.close,
                      iconSize: ImageSizeEnum.small.size - 10,
                      onTap: () {
                        context.read<BaseDrawerController>().closeDrawer();
                      },
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
