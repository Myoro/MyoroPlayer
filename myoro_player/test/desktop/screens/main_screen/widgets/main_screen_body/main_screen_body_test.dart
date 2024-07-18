import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/song_controls_bloc/song_controlsl_bloc.dart';
import 'package:myoro_player/shared/blocs/song_listing_bloc/song_listing_bloc.dart';
import 'package:myoro_player/shared/blocs/user_preferences_cubit.dart';
import 'package:myoro_player/shared/models/user_preferences.dart';
import 'package:myoro_player/shared/services/song_service/song_service.dart';
import 'package:myoro_player/shared/services/user_preferences_service/user_preferences_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/shared/blocs/playlist_listing_bloc/playlist_listing_bloc.dart';
import 'package:myoro_player/desktop/screens/main_screen/widgets/main_screen_body/main_screen_body.dart';
import 'package:myoro_player/desktop/screens/main_screen/widgets/main_screen_body/main_screen_body_footer.dart';
import 'package:myoro_player/desktop/screens/main_screen/widgets/main_screen_body/main_screen_body_playlist_side_bar.dart';
import 'package:myoro_player/desktop/screens/main_screen/widgets/main_screen_body/main_screen_body_song_list.dart';
import 'package:myoro_player/shared/helpers/file_system_helper.dart';
import 'package:myoro_player/shared/services/playlist_service/playlist_service.dart';
import 'package:myoro_player/shared/widgets/dividers/basic_divider.dart';

import '../../../../../base_test_widget.dart';
import '../../../../../mocks/file_system_helper_mock.dart';
import '../../../../../mocks/playlist_service_mock.dart';
import '../../../../../mocks/song_service.mock.dart';
import '../../../../../mocks/user_preferences_mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();
  late final UserPreferencesCubit userPreferencesCubit;

  setUp(() {
    kiwiContainer
      ..registerFactory<UserPreferencesService>((_) => UserPreferencesServiceMock.preConfigured())
      ..registerFactory<FileSystemHelper>((_) => FileSystemHelperMock())
      ..registerFactory<PlaylistService>((_) => PlaylistServiceMock.preConfigured())
      ..registerFactory<SongService>((_) => SongServiceMock.preConfigured());

    userPreferencesCubit = UserPreferencesCubit(UserPreferences.mock);
  });

  tearDown(() {
    kiwiContainer.clear();
    userPreferencesCubit.close();
  });

  testWidgets('MainScreenBody widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => userPreferencesCubit),
            BlocProvider(create: (context) => PlaylistListingBloc()),
            BlocProvider(create: (context) => SongListingBloc()),
            BlocProvider(create: (context) => SongControlsBloc(userPreferencesCubit)),
          ],
          child: const MainScreenBody(),
        ),
      ),
    );

    expect(find.byType(MainScreenBody), findsOneWidget);

    expect(
      find.byWidgetPredicate((w) => (w is Row &&
          w.children.length == 2 &&
          w.children.first is MainScreenBodyPlaylistSideBar &&
          w.children.last is Expanded &&
          (w.children.last as Expanded).child is Column)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => (w is Column &&
          w.children.length == 3 &&
          w.children.first is MainScreenBodySongList &&
          w.children[1] is BasicDivider &&
          w.children.last is MainScreenBodyFooter)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (w) => w is BasicDivider && w.direction == Axis.horizontal && w.padding == const EdgeInsets.symmetric(horizontal: 10),
      ),
      findsNWidgets(3),
    );
  });
}
