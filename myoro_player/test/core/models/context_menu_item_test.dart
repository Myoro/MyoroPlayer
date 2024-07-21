import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/core/models/context_menu_item.dart';

void main() {
  test('ContextMenuItem unit test.', () {
    final item = ContextMenuItem(
      icon: Icons.abc,
      text: 'Text',
      onTap: () {},
    );
    final copyItem = item.copyWith();
    final uniqueItem = item.copyWith(icon: Icons.ac_unit);

    expect(item == copyItem, isTrue);
    expect(item == uniqueItem, isFalse);

    expect(
      item.toString(),
      'ContextMenuItem(\n'
      '  icon: ${item.icon},\n'
      '  text: ${item.text},\n'
      '  onTap: ${item.onTap},\n'
      ');',
    );
  });
}
