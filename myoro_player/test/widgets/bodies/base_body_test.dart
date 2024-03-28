import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/shared/widgets/bodies/base_body.dart';

import '../../base_test_widget.dart';

void main() {
  testWidgets('BaseBody Widget Test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        testType: TestTypeEnum.widget,
        child: BaseBody(
          child: Text('Working'),
        ),
      ),
    );

    expect(find.byType(BaseBody), findsOneWidget);
    expect(find.byType(Padding), findsOneWidget);
    expect(find.byType(SizedBox), findsOneWidget);
    expect(find.byType(Text), findsOneWidget);
    expect(find.text('Working'), findsOneWidget);
  });
}
