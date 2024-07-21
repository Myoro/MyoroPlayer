import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/shared/blocs/song_controls_bloc/song_controls_bloc.dart';
import 'package:myoro_player/shared/blocs/song_listing_bloc/song_listing_bloc.dart';
import 'package:myoro_player/shared/blocs/user_preferences_cubit.dart';
import 'package:myoro_player/core/helpers/file_system_helper.dart';
import 'package:myoro_player/core/models/user_preferences.dart';
import 'package:myoro_player/core/services/playlist_service/playlist_service.dart';
import 'package:myoro_player/core/services/song_service/song_service.dart';
import 'package:myoro_player/core/services/user_preferences_service/user_preferences_service.dart';
import 'package:myoro_player/core/widgets/buttons/icon_text_hover_button.dart';
import 'package:myoro_player/core/widgets/inputs/underline_input.dart';
import 'package:myoro_player/core/widgets/scrollbars/vertical_scroll_list.dart';
import 'package:myoro_player/shared/screens/main_screen/playlist_listing.dart';

import '../../../base_test_widget.dart';
import '../../../mocks/file_system_helper_mock.dart';
import '../../../mocks/playlist_service_mock.dart';
import '../../../mocks/song_service.mock.dart';
import '../../../mocks/user_preferences_mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();
  late final UserPreferencesCubit userPreferencesCubit;

  setUp(() {
    kiwiContainer
      ..registerFactory<FileSystemHelper>((_) => FileSystemHelperMock.preConfigured())
      ..registerFactory<UserPreferencesService>((_) => UserPreferencesServiceMock.preConfigured())
      ..registerFactory<SongService>((_) => SongServiceMock.preConfigured())
      ..registerFactory<PlaylistService>((_) => PlaylistServiceMock.preConfigured());

    userPreferencesCubit = UserPreferencesCubit(UserPreferences.mock);
  });

  tearDown(() {
    kiwiContainer.clear();
    userPreferencesCubit.close();
  });

  testWidgets('PlaylistListing widget test.', (tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: userPreferencesCubit),
          BlocProvider(create: (context) => SongListingBloc()),
          BlocProvider(create: (context) => SongControlsBloc(userPreferencesCubit)),
        ],
        child: const BaseTestWidget(
          child: Column(
            children: [
              PlaylistListing(),
            ],
          ),
        ),
      ),
    );

    await tester.pump();

    expect(find.byType(PlaylistListing), findsOneWidget);

    expect(
      find.byWidgetPredicate((w) => (w is VerticalScrollList && w.children.length == PlaylistServiceMock.preConfiguredPlaylists.length + 1)),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate((w) => w is UnderlineInput && w.placeholder == 'Search playlists'),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate((w) => (w is Padding && w.padding == const EdgeInsets.only(top: 5, bottom: 0) && w.child is Tooltip)),
      findsNWidgets(PlaylistServiceMock.preConfiguredPlaylists.length - 1),
    );
    expect(
      find.byWidgetPredicate((w) => (w is Padding && w.padding == const EdgeInsets.only(top: 5, bottom: 5) && w.child is Tooltip)),
      findsOneWidget,
    );
    for (final playlist in PlaylistServiceMock.preConfiguredPlaylists) {
      expect(
        find.byWidgetPredicate(
          (w) =>
              w is IconTextHoverButton &&
              w.padding ==
                  const EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                    left: 8,
                    right: 5,
                  ) &&
              w.text == playlist.name,
        ),
        findsOneWidget,
      );
    }

    final playlistFinder = find
        .byWidgetPredicate(
          (w) =>
              w is IconTextHoverButton &&
              w.padding ==
                  const EdgeInsets.only(
                    top: 5,
                    bottom: 5,
                    left: 8,
                    right: 5,
                  ),
        )
        .first;

    // Loading a playlist
    await tester.tap(playlistFinder);
    await tester.pump();

    // Searchbar functionality
    await tester.enterText(find.byType(UnderlineInput), PlaylistServiceMock.preConfiguredPlaylists.first.name);
    await tester.pump();
    expect(
      find.byWidgetPredicate((w) => (w is VerticalScrollList && w.children.length < PlaylistServiceMock.preConfiguredPlaylists.length)),
      findsOneWidget,
    );

    // The [Playlist] context menu
    await tester.tap(playlistFinder, buttons: kSecondaryButton);
    await tester.pump();
    expect(find.byType(PopupMenuItem<dynamic>), findsAtLeastNWidgets(1));
  });
}
