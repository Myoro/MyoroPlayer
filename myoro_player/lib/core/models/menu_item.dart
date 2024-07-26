import 'package:equatable/equatable.dart';
import 'package:faker/faker.dart';
import 'package:flutter/material.dart';
import 'package:myoro_player/core/helpers/context_menu_helper.dart';
import 'package:myoro_player/mobile/widgets/modals/base_dropdown_modal.dart';

/// Used to pass item data to [ContextMenuHelper] & [BaseDropdownModal]
final class MenuItem extends Equatable {
  final IconData icon;
  final String text;
  final VoidCallback onTap;

  const MenuItem({
    required this.icon,
    required this.text,
    required this.onTap,
  });

  MenuItem copyWith({
    IconData? icon,
    String? text,
    VoidCallback? onTap,
  }) {
    return MenuItem(
      icon: icon ?? this.icon,
      text: text ?? this.text,
      onTap: onTap ?? this.onTap,
    );
  }

  MenuItem.fake({required this.onTap})
      : icon = [Icons.abc, Icons.ac_unit, Icons.catching_pokemon, Icons.access_alarm, Icons.zoom_out_sharp][faker.randomGenerator.integer(5)],
        text = faker.randomGenerator.string(50);

  @override
  String toString() => 'MenuItem(\n'
      '  icon: $icon,\n'
      '  text: $text,\n'
      '  onTap: $onTap,\n'
      ');';

  @override
  List<Object?> get props => [icon, text, onTap];
}
