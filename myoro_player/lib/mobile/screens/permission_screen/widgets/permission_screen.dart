import 'package:flutter/material.dart';
import 'package:myoro_player/core/design_system/color_design_system.dart';
import 'package:myoro_player/core/design_system/image_design_system.dart';
import 'package:myoro_player/core/enums/image_size_enum.dart';
import 'package:myoro_player/core/widgets/buttons/icon_text_hover_button.dart';
import 'package:myoro_player/core/widgets/images/base_image.dart';
import 'package:myoro_player/core/widgets/scaffolds/base_scaffold.dart';
import 'package:myoro_player/mobile/blocs/permission_cubit.dart';
import 'package:permission_handler/permission_handler.dart';

/// Screen used to welcome and grab permissions from the user
final class PermissionScreen extends StatelessWidget {
  final PermissionCubit permissionCubit;

  const PermissionScreen(this.permissionCubit, {super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return BaseScaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              BaseImage(
                svgPath: ImageDesignSystem.logo,
                svgColor: ColorDesignSystem.onBackground(context),
                size: ImageSizeEnum.large.size + 50,
              ),
              const SizedBox(height: 30),
              Text(
                'Welcome to MyoroPlayer!',
                style: textTheme.titleLarge,
              ),
              const SizedBox(height: 30),
              Text(
                'In order to use MyoroPlayer, you must allow storage & audio permissions.',
                textAlign: TextAlign.center,
                style: textTheme.headlineMedium,
              ),
              const SizedBox(height: 30),
              Row(
                children: [
                  _Button(
                    'App Settings',
                    () => openAppSettings(),
                  ),
                  const SizedBox(width: 10),
                  _Button(
                    'Use MyoroPlayer!',
                    () async {
                      Navigator.of(context).pop();
                      await Future.delayed(const Duration(milliseconds: 700));
                      permissionCubit.checkPermissions();
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

final class _Button extends StatelessWidget {
  final String text;
  final VoidCallback onPressed;

  const _Button(
    this.text,
    this.onPressed,
  );

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: IconTextHoverButton(
        text: text,
        textStyle: Theme.of(context).textTheme.bodySmall!.copyWith(fontSize: 14.5),
        textAlign: TextAlign.center,
        bordered: true,
        padding: const EdgeInsets.all(5),
        onTap: onPressed,
      ),
    );
  }
}
