import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:myoro_player/shared/helpers/context_menu_helper.dart';

/// Used to pass item data to [ContextMenuHelper]
final class ContextMenuItem extends Equatable {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const ContextMenuItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  ContextMenuItem copyWith({
    IconData? icon,
    String? text,
    VoidCallback? onTap,
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
