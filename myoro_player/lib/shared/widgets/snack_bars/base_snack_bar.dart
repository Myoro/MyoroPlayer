import 'package:flutter/material.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/design_system/decoration_design_system.dart';
import 'package:myoro_player/shared/enums/image_size_enum.dart';
import 'package:myoro_player/shared/enums/snack_bar_type_enum.dart';
import 'package:myoro_player/shared/extensions/build_context_extension.dart';
import 'package:myoro_player/shared/extensions/text_style_extension.dart';
import 'package:myoro_player/shared/helpers/snack_bar_helper.dart';
import 'package:myoro_player/shared/widgets/buttons/no_feedback_button.dart';

final class BaseSnackBar extends SnackBar {
  BaseSnackBar({
    super.key,
    required SnackBarTypeEnum snackBarType,
    required String message,
  }) : super(
          behavior: SnackBarBehavior.floating,
          backgroundColor: ColorDesignSystem.transparent,
          elevation: 0,
          content: Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              _SnackBar(
                snackBarType,
                message,
              ),
            ],
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
              onTap: () => KiwiContainer().resolve<SnackBarHelper>().closeSnackBar(context),
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
