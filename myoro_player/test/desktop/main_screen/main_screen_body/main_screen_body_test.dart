import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/desktop/main_screen/main_screen_body/main_screen_body.dart';
import 'package:myoro_player/desktop/main_screen/main_screen_body/playlist_side_bar.dart';
import 'package:myoro_player/desktop/main_screen/main_screen_body/song_list.dart';
import 'package:myoro_player/widgets/bodies/base_body.dart';

import '../../../base_test_widget.dart';

void main() {
  testWidgets('MainScreenBody Widget Test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        testType: TestTypeEnum.widget,
        child: MainScreenBody(),
      ),
    );

    expect(find.byType(MainScreenBody), findsOneWidget);
    expect(find.byType(BaseBody), findsOneWidget);
    expect(find.byType(PlaylistSideBar), findsOneWidget);
    expect(find.byType(SongList), findsOneWidget);
  });
}
