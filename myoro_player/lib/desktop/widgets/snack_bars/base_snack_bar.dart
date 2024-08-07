import 'package:flutter/material.dart';
import 'package:myoro_player/core/design_system/color_design_system.dart';
import 'package:myoro_player/core/design_system/decoration_design_system.dart';
import 'package:myoro_player/core/enums/image_size_enum.dart';
import 'package:myoro_player/core/enums/snack_bar_type_enum.dart';
import 'package:myoro_player/core/extensions/build_context_extension.dart';
import 'package:myoro_player/core/extensions/text_style_extension.dart';
import 'package:myoro_player/core/widgets/buttons/no_feedback_button.dart';

final class BaseSnackBar extends SnackBar {
  BaseSnackBar(
    BuildContext context, {
    super.key,
    required SnackBarTypeEnum snackBarType,
    required String message,
  }) : super(
          behavior: SnackBarBehavior.floating,
          backgroundColor: ColorDesignSystem.transparent,
          elevation: 0,
          padding: const EdgeInsets.only(bottom: 5),
          margin: EdgeInsets.only(
            top: 5,
            bottom: 5,
            // If this line wasn't here, the snack bar
            // would have a width of double.infinity
            // disallowing the user to click anywhere
            // on the bottom of the screen.
            right: MediaQuery.of(context).size.width - 300,
          ),
          content: Padding(
            padding: const EdgeInsets.only(
              left: 10,
            ),
            child: _SnackBar(
              snackBarType,
              message,
            ),
          ),
        );
}

final class _SnackBar extends StatelessWidget {
  final SnackBarTypeEnum snackBarType;
  final String message;

  const _SnackBar(this.snackBarType, this.message);

  @override
  Widget build(BuildContext context) {
    final Color onBackground = ColorDesignSystem.onBackground(context);

    return Container(
      width: 300,
      decoration: BoxDecoration(
        color: snackBarType.isTypeError ? ColorDesignSystem.error : ColorDesignSystem.background(context),
        borderRadius: DecorationDesignSystem.borderRadius,
        border: Border.all(
          width: 2,
          color: snackBarType.isTypeError ? ColorDesignSystem.error : onBackground,
        ),
      ),
      child: Padding(
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
    );
  }
}
