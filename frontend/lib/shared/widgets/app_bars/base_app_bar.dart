import 'package:flutter/material.dart';

/// Used whenever creating an [AppBar]
///
/// Whenever using this class, the class must be implement [PreferredSizeWidget]:
/// ``` dart
/// final class FooAppBar extends StatelessWidget implements PreferredSizeWidget {
///   const FooAppBar({super.key});
///
///   @override
///   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
///
///   @override
///   Widget build(BuildContext context) => BaseAppBar(...);
/// }
/// ```
final class BaseAppBar extends StatelessWidget {
  final List<Widget> children;

  const BaseAppBar({super.key, required this.children});

  @override
  Widget build(BuildContext context) => AppBar(title: Row(children: children));
}
