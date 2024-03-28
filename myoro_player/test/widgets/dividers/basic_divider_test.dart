import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/shared/enums/divider_type_enum.dart';
import 'package:myoro_player/shared/widgets/dividers/basic_divider.dart';

import '../../base_test_widget.dart';

void main() {
  testWidgets('BasicDivider Widget Test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        testType: TestTypeEnum.widget,
        child: Column(
          children: [
            BasicDivider(
              dividerType: DividerTypeEnum.horizontal,
            ),
            SizedBox(
              height: 200,
              child: BasicDivider(
                dividerType: DividerTypeEnum.vertical,
              ),
            ),
          ],
        ),
      ),
    );

    expect(find.byType(BasicDivider), findsNWidgets(2));
    expect(find.byType(MouseRegion), findsNWidgets(3));
    expect(find.byType(GestureDetector), findsNWidgets(2));
    expect(find.byType(Container), findsNWidgets(4));
    expect(find.byType(Stack), findsNWidgets(3));
  });
}
