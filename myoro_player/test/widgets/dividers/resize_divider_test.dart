import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/shared/enums/divider_type_enum.dart';
import 'package:myoro_player/shared/widgets/dividers/resize_divider.dart';

import '../../base_test_widget.dart';

void main() {
  testWidgets('ResizeDivider Widget Test', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        testType: TestTypeEnum.widget,
        child: Column(
          children: [
            ResizeDivider(
              dividerType: DividerTypeEnum.horizontal,
              onVerticalDragUpdate: (_) {},
            ),
            SizedBox(
              height: 200,
              child: ResizeDivider(
                dividerType: DividerTypeEnum.vertical,
                onHorizontalDragUpdate: (_) {},
              ),
            ),
          ],
        ),
      ),
    );

    expect(find.byType(ResizeDivider), findsNWidgets(2));
    expect(find.byType(MouseRegion), findsNWidgets(3));
    expect(find.byType(GestureDetector), findsNWidgets(2));
    expect(find.byType(Container), findsNWidgets(6));
    expect(find.byType(Stack), findsNWidgets(3));
  });
}
