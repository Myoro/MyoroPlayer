import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/desktop/main_screen/main_screen_body/song_list.dart';
import 'package:myoro_player/shared/widgets/dividers/basic_divider.dart';

import '../../../base_test_widget.dart';

void main() {
  testWidgets('SongList Widget Test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        testType: TestTypeEnum.widget,
        child: Row(
          children: [
            SongList(),
          ],
        ),
      ),
    );

    expect(find.byType(SongList), findsOneWidget);
    expect(find.text('<PLAYLIST NAME HERE>'), findsOneWidget);
    expect(find.byType(BasicDivider), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);
  });
}
