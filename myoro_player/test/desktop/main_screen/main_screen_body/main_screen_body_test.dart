// ignore_for_file: deprecated_member_use

import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/shared/blocs/playlist_cubit.dart';
import 'package:myoro_player/shared/database.dart';
import 'package:myoro_player/desktop/main_screen/main_screen_body/main_screen_body.dart';
import 'package:myoro_player/desktop/main_screen/main_screen_body/playlist_side_bar.dart';
import 'package:myoro_player/desktop/main_screen/main_screen_body/song_list.dart';
import 'package:myoro_player/shared/widgets/bodies/base_body.dart';

import '../../../base_test_widget.dart';

void main() {
  setUpAll(() async {
    const MethodChannel('plugins.flutter.io/path_provider').setMockMethodCallHandler((MethodCall methodCall) async {
      if (methodCall.method == 'getApplicationSupportDirectory') return '.';
    });
    await Database.init();
  });

  testWidgets('MainScreenBody Widget Test', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        testType: TestTypeEnum.widget,
        child: BlocProvider(
          create: (context) => PlaylistCubit(),
          child: const MainScreenBody(),
        ),
      ),
    );

    expect(find.byType(MainScreenBody), findsOneWidget);
    expect(find.byType(BaseBody), findsOneWidget);
    expect(find.byType(PlaylistSideBar), findsOneWidget);
    expect(find.byType(SongList), findsOneWidget);
  });
}
