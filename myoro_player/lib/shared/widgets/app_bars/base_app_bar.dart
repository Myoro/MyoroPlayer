import 'package:flutter/material.dart';

/// Every app bar of every screen must have [BaseAppBar] as it's root widget
///
/// Every app bar of MyoroPlayer must implement [PreferredSizeWidget] like so:
/// ``` dart
/// final class FooAppBar extends StatelessWidget implements PreferredSizeWidget {
///   const FooAppBar({ super.key });
///
///   @override
///   Size get preferredSize => const Size.fromHeight(kToolbarHeight);
///
///   @override
///   Widget build(BuildContext context) { ... }
/// }
/// ```
final class BaseAppBar extends StatelessWidget {
  final List<Widget> children;

  const BaseAppBar({super.key, required this.children});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Row(
        children: children,
      ),
    );
  }
}
