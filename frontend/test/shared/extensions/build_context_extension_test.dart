import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/extensions/build_context_extension.dart';

import '../../base_test_widget.dart';

void main() {
  testWidgets('BuildContextExtension test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        themeMode: ThemeMode.light,
        child: Builder(
          builder: (context) {
            expect(context.isDarkMode, isFalse);
            expect(context.textTheme.runtimeType == TextTheme, isTrue);

            return const SizedBox.shrink();
          },
        ),
      ),
    );
  });
}
