import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/core/helpers/platform_helper.dart';
import 'package:myoro_player/shared/blocs/song_controls_bloc/song_controls_bloc.dart';
import 'package:myoro_player/shared/blocs/song_listing_bloc/song_listing_bloc.dart';
import 'package:myoro_player/shared/blocs/user_preferences_cubit.dart';
import 'package:myoro_player/core/models/user_preferences.dart';
import 'package:myoro_player/core/services/song_service/song_service.dart';
import 'package:myoro_player/core/services/user_preferences_service/user_preferences_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/shared/blocs/playlist_listing_bloc/playlist_listing_bloc.dart';
import 'package:myoro_player/desktop/screens/main_screen/widgets/main_screen.dart';
import 'package:myoro_player/desktop/screens/main_screen/widgets/main_screen_app_bar/main_screen_app_bar.dart';
import 'package:myoro_player/desktop/screens/main_screen/widgets/main_screen_body/main_screen_body.dart';
import 'package:myoro_player/core/helpers/file_system_helper.dart';
import 'package:myoro_player/core/services/playlist_service/playlist_service.dart';
import 'package:myoro_player/core/widgets/scaffolds/base_scaffold.dart';

import '../../../../base_test_widget.dart';
import '../../../../mocks/file_system_helper_mock.dart';
import '../../../../mocks/platform_helper_mock.dart';
import '../../../../mocks/playlist_service_mock.dart';
import '../../../../mocks/song_service.mock.dart';
import '../../../../mocks/user_preferences_mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();
  late final UserPreferencesCubit userPreferencesCubit;

  setUp(() {
    kiwiContainer
      ..registerFactory<PlatformHelper>((_) => PlatformHelperMock.preConfigured())
      ..registerFactory<FileSystemHelper>((_) => FileSystemHelperMock())
      ..registerFactory<UserPreferencesService>((_) => UserPreferencesServiceMock.preConfigured())
      ..registerFactory<PlaylistService>((_) => PlaylistServiceMock.preConfigured(playlists: []))
      ..registerFactory<SongService>((_) => SongServiceMock.preConfigured());

    userPreferencesCubit = UserPreferencesCubit(UserPreferences.mock);
  });

  tearDown(() {
    kiwiContainer.clear();
    userPreferencesCubit.close();
  });

  testWidgets('MainScreen widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        testType: TestTypeEnum.screen,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => userPreferencesCubit),
            BlocProvider(create: (context) => PlaylistListingBloc()),
            BlocProvider(create: (context) => SongListingBloc()),
            BlocProvider(create: (context) => SongControlsBloc(userPreferencesCubit)),
          ],
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
