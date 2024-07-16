import 'package:flutter/material.dart';

final class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: const Text(
        'Hello, World!',
      ),
    );
  }
}
