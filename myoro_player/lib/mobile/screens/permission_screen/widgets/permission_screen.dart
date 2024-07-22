import 'package:flutter/material.dart';
import 'package:myoro_player/core/widgets/scaffolds/base_scaffold.dart';

/// Screen used to welcome and grab permissions from the user
final class PermissionScreen extends StatelessWidget {
  const PermissionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const BaseScaffold(
      body: SafeArea(
        child: Text('Hey'),
      ),
    );
  }
}
