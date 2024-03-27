import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/blocs/playlist_cubit.dart';
import 'package:myoro_player/desktop/main_screen/main_screen.dart';
import 'package:myoro_player/desktop/main_screen/main_screen_app_bar.dart';
import 'package:myoro_player/desktop/main_screen/main_screen_body/main_screen_body.dart';

import '../../base_test_widget.dart';

void main() {
  testWidgets('MainScreen Widget Test', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        testType: TestTypeEnum.screen,
        child: BlocProvider(
          create: (context) => PlaylistCubit(),
          child: const MainScreen(),
        ),
      ),
    );

    expect(find.byType(MainScreen), findsOneWidget);
    expect(find.byType(MainScreenAppBar), findsOneWidget);
    expect(find.byType(MainScreenBody), findsOneWidget);
  });
}
