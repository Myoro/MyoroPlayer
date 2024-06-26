import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:frontend/shared/helpers/context_menu_helper.dart';

/// Used to pass item data to [ContextMenuHelper]
final class ContextMenuItem extends Equatable {
  final IconData icon;
  final String text;
  final Function(BuildContext context) onTap;

  const ContextMenuItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  ContextMenuItem copyWith({
    IconData? icon,
    String? text,
    Function(BuildContext context)? onTap,
  }) {
    return ContextMenuItem(
      icon: icon ?? this.icon,
      text: text ?? this.text,
      onTap: onTap ?? this.onTap,
    );
  }

  @override
  String toString() => 'ContextMenuItem(\n'
      '  icon: $icon,\n'
      '  text: $text,\n'
      '  onTap: $onTap,\n'
      ');';

  @override
  List<Object?> get props => [icon, text, onTap];
}
