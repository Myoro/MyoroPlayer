import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/core/models/menu_item.dart';

void main() {
  test('MenuItem unit test.', () {
    final item = MenuItem(
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
      'MenuItem(\n'
      '  icon: ${item.icon},\n'
      '  text: ${item.text},\n'
      '  onTap: ${item.onTap},\n'
      ');',
    );
  });
}
