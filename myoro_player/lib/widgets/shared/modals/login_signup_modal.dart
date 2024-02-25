import 'package:flutter/material.dart';
import 'package:bcrypt/bcrypt.dart';
import 'package:myoro_player/enums/login_signup_enum.dart';
import 'package:myoro_player/widgets/shared/inputs/base_text_field_form.dart';
import 'package:myoro_player/widgets/shared/modals/base_modal.dart';

class LoginSignupModal extends StatefulWidget {
  final LoginSignupEnum mode;

  const LoginSignupModal({super.key, required this.mode});

  static void show(BuildContext context, mode) => showDialog(
        context: context,
        barrierDismissible: false,
        builder: (context) => LoginSignupModal(mode: mode),
      );

  @override
  State<LoginSignupModal> createState() => _LoginSignupModalState();
}

class _LoginSignupModalState extends State<LoginSignupModal> {
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final ValueNotifier<String?> _showErrorMessage = ValueNotifier<String?>(null);

  void _submit() {
    if (_usernameController.text.isEmpty || _passwordController.text.isEmpty) {
      _showErrorMessage.value = 'Username/password field empty';
      Future.delayed(const Duration(milliseconds: 1500),
          () => _showErrorMessage.value = null);
      return;
    }

    if (widget.mode == LoginSignupEnum.signup) {
      final String salt = BCrypt.gensalt();
      final String hashedPassword =
          BCrypt.hashpw(_passwordController.text, salt);

      print(hashedPassword);

      // TODO
    } else {
      // TODO
      print('Complete login');
    }
  }

  @override
  void dispose() {
    _usernameController.dispose();
    _passwordController.dispose();
    _showErrorMessage.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    const double textFieldWidth = 150;

    return ValueListenableBuilder(
      valueListenable: _showErrorMessage,
      builder: (context, showErrorMessage, child) => BaseModal(
        size: Size(275, showErrorMessage == null ? 200 : 240),
        title: widget.mode == LoginSignupEnum.login
            ? 'Login'
            : 'Create an account',
        showFooterButtons: true,
        yesOnTap: () => _submit(),
        content: Column(
          children: [
            BaseTextFieldForm(
              title: 'Username',
              controller: _usernameController,
              textFieldWidth: textFieldWidth,
            ),
            BaseTextFieldForm(
              title: 'Password',
              controller: _passwordController,
              textFieldWidth: textFieldWidth,
              obscureText: true,
            ),
            if (showErrorMessage != null) ...[
              const SizedBox(height: 20),
              Text(
                showErrorMessage,
                style: Theme.of(context).textTheme.headlineSmall,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
