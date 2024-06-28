import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_bloc.dart';
import 'package:myoro_player/screens/main_screen/widgets/main_screen.dart';
import 'package:myoro_player/screens/main_screen/widgets/main_screen_app_bar/main_screen_app_bar.dart';
import 'package:myoro_player/screens/main_screen/widgets/main_screen_body/main_screen_body.dart';
import 'package:myoro_player/shared/helpers/file_system_helper.dart';
import 'package:myoro_player/shared/helpers/snack_bar_helper.dart';
import 'package:myoro_player/shared/services/playlist_service/playlist_service.dart';
import 'package:myoro_player/shared/widgets/scaffolds/base_scaffold.dart';

import '../../../base_test_widget.dart';
import '../../../mocks/file_system_helper_mock.dart';
import '../../../mocks/playlist_service_mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();

  setUp(() {
    kiwiContainer
      ..registerFactory<SnackBarHelper>((_) => SnackBarHelper())
      ..registerFactory<FileSystemHelper>((_) => FileSystemHelperMock())
      ..registerFactory<PlaylistService>((_) => PlaylistServiceMock.preConfigured());
  });
  tearDown(() => kiwiContainer.clear());

  testWidgets('MainScreen widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        testType: TestTypeEnum.screen,
        child: BlocProvider(
          create: (context) => MainScreenBodyPlaylistSideBarBloc(),
          child: const MainScreen(),
        ),
      ),
    );

    expect(find.byType(MainScreen), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is BaseScaffold && w.appBar is MainScreenAppBar && w.body is MainScreenBody,
      ),
      findsOneWidget,
    );
  });
}
