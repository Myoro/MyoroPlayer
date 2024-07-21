import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/core/extensions/text_style_extension.dart';

void main() {
  test('TestStyleExtension.withColor', () {
    const style = TextStyle(color: Colors.red);
    expect(style.color, Colors.red);
    expect(style.withColor(Colors.green).color, Colors.green);
  });
}
