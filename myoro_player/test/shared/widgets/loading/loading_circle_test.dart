import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/widgets/loading/loading_circle.dart';

import '../../../base_test_widget.dart';

void main() {
  testWidgets('LoadingCircle widget test.', (tester) async {
    await tester
        .pumpWidget(const BaseTestWidget(themeMode: ThemeMode.dark, child: LoadingCircle()));
    expect(find.byType(LoadingCircle), findsOneWidget);
    expect(
      find.byWidgetPredicate((w) =>
          w is CircularProgressIndicator && w.color == DarkModeColorDesignSystem.onBackground),
      findsOneWidget,
    );
  });
}
