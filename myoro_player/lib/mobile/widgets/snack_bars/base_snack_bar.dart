import 'package:flutter/material.dart';
import 'package:myoro_player/core/design_system/color_design_system.dart';
import 'package:myoro_player/core/enums/image_size_enum.dart';
import 'package:myoro_player/core/enums/snack_bar_type_enum.dart';
import 'package:myoro_player/core/extensions/build_context_extension.dart';
import 'package:myoro_player/core/extensions/text_style_extension.dart';
import 'package:myoro_player/core/widgets/buttons/no_feedback_button.dart';
import 'package:myoro_player/core/widgets/dividers/basic_divider.dart';

final class BaseSnackBar extends SnackBar {
  BaseSnackBar(
    BuildContext context, {
    super.key,
    required SnackBarTypeEnum snackBarType,
    required String message,
  }) : super(
          backgroundColor: ColorDesignSystem.background(context),
          padding: EdgeInsets.zero,
          content: _SnackBar(
            snackBarType,
            message,
          ),
        );
}

final class _SnackBar extends StatelessWidget {
  final SnackBarTypeEnum snackBarType;
  final String message;

  const _SnackBar(
    this.snackBarType,
    this.message,
  );

  @override
  Widget build(BuildContext context) {
    final onBackground = ColorDesignSystem.onBackground(context);

    return Column(
      children: [
        const BasicDivider(
          direction: Axis.horizontal,
        ),
        Padding(
          padding: const EdgeInsets.all(10),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  message,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: context.textTheme.bodySmall!.withColor(
                    snackBarType.isTypeError ? ColorDesignSystem.onError : onBackground,
                  ),
                ),
              ),
              const SizedBox(width: 5),
              NoFeedbackButton(
                onTap: () => context.closeSnackBar(),
                child: Icon(
                  Icons.close,
                  size: ImageSizeEnum.small.size - 10,
                  color: snackBarType.isTypeError ? ColorDesignSystem.onError : onBackground,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
