import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/song_controls_bloc/song_controlsl_bloc.dart';
import 'package:myoro_player/shared/blocs/song_listing_bloc/song_listing_bloc.dart';
import 'package:myoro_player/shared/blocs/user_preferences_cubit.dart';
import 'package:myoro_player/shared/models/user_preferences.dart';
import 'package:myoro_player/shared/services/song_service/song_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/shared/blocs/playlist_listing_bloc/playlist_listing_bloc.dart';
import 'package:myoro_player/desktop/screens/main_screen/widgets/main_screen_body/main_screen_body_playlist_side_bar.dart';
import 'package:myoro_player/shared/helpers/file_system_helper.dart';
import 'package:myoro_player/shared/services/playlist_service/playlist_service.dart';
import 'package:myoro_player/shared/services/user_preferences_service/user_preferences_service.dart';
import 'package:myoro_player/shared/widgets/dividers/resize_divider.dart';
import 'package:myoro_player/shared/widgets/headers/underline_header.dart';
import 'package:myoro_player/shared/widgets/specific/playlist_listing.dart';

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
      ..registerFactory<FileSystemHelper>((_) => FileSystemHelperMock.preConfigured())
      ..registerFactory<PlaylistService>((_) => PlaylistServiceMock.preConfigured())
      ..registerFactory<SongService>((_) => SongServiceMock.preConfigured());

    userPreferencesCubit = UserPreferencesCubit(UserPreferences.mock);
  });

  tearDown(() {
    kiwiContainer.clear();
    userPreferencesCubit.close();
  });

  testWidgets('MainScreenBodyPlaylistSideBar widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => userPreferencesCubit),
            BlocProvider(create: (_) => PlaylistListingBloc()),
            BlocProvider(create: (_) => SongListingBloc()),
            BlocProvider(create: (_) => SongControlsBloc(userPreferencesCubit)),
          ],
          child: const MainScreenBodyPlaylistSideBar(),
        ),
      ),
    );

    await tester.pump(); // Let the [ModelResolver<List<Playlist>>] load

    expect(find.byType(MainScreenBodyPlaylistSideBar), findsOneWidget);
    expect(find.byType(ValueListenableBuilder<double>), findsOneWidget);
    expect(
      find.byWidgetPredicate((w) => (w is Container && w.constraints?.minWidth == 180 && w.child is Row && (w.child as Row).children.length == 2)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => (w is Expanded &&
          w.child is Column &&
          (w.child as Column).children.length == 2 &&
          (w.child as Column).children.first is UnderlineHeader &&
          ((w.child as Column).children.first as UnderlineHeader).header == 'Playlists' &&
          (w.child as Column).children.last is PlaylistListing)),
      findsOneWidget,
    );

    // [_ResizeDivider]
    expect(
      find.byWidgetPredicate((w) => (w is ResizeDivider && w.direction == Axis.vertical && w.padding == const EdgeInsets.only(top: 40, bottom: 15))),
      findsOneWidget,
    );

    // Testing resize divider
    await tester.drag(find.byType(ResizeDivider), const Offset(50, 0));
  });
}
