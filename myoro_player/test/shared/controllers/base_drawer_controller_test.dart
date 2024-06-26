import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/main.dart';
import 'package:myoro_player/shared/widgets/drawers/base_drawer.dart';

void main() {
  testWidgets('BaseControllerDrawer Test', (tester) async {
    await tester.pumpWidget(const App());
    await tester.tap(find.byIcon(Icons.menu));
    await tester.pump();
    expect(find.byType(BaseDrawer), findsOneWidget);
  });
}
