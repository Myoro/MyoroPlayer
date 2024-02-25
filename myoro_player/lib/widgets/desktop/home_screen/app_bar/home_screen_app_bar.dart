import 'package:flutter/material.dart';
import 'package:myoro_player/enums/login_signup_enum.dart';
import 'package:myoro_player/widgets/shared/buttons/base_hover_button.dart';
import 'package:myoro_player/widgets/shared/buttons/base_dropdown.dart';
import 'package:myoro_player/widgets/shared/modals/login_signup_modal.dart';

class HomeScreenAppBar extends StatelessWidget implements PreferredSizeWidget {
  const HomeScreenAppBar({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) => AppBar(
        title: Row(
          children: [
            Text(
              'MyoroPlayer',
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(width: 10),
            BaseDropdown(
              items: const [
                'This',
                'Is',
                'A',
                'Test',
              ],
              child: BaseHoverButton(text: 'File'),
            ),
            const SizedBox(width: 10),
            BaseDropdown(
              items: const [
                'This',
                'Is',
                'A',
                'Test',
              ],
              child: BaseHoverButton(text: 'View'),
            ),
            const SizedBox(width: 10),
            BaseDropdown(
              items: const [
                'This',
                'Is',
                'A',
                'Test',
              ],
              child: BaseHoverButton(text: 'Streaming'),
            ),
            const Spacer(),
            BaseHoverButton(
              onTap: () =>
                  LoginSignupModal.show(context, LoginSignupEnum.login),
              text: 'Login',
            ),
            const SizedBox(width: 10),
            BaseHoverButton(
              onTap: () =>
                  LoginSignupModal.show(context, LoginSignupEnum.signup),
              text: 'Signup',
            ),
          ],
        ),
      );
}
