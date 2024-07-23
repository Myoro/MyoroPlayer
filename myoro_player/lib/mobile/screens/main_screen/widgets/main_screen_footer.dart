import 'package:flutter/material.dart';

final class MainScreenFooter extends StatelessWidget {
  const MainScreenFooter({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.red,
      child: const Text(
        'Display song information here',
      ),
    );
  }
}
