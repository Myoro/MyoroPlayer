import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_footer_bloc/main_screen_body_footer_bloc.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_bloc.dart';
import 'package:myoro_player/shared/blocs/user_preferences_cubit.dart';
import 'package:myoro_player/shared/helpers/file_system_helper.dart';
import 'package:myoro_player/shared/models/user_preferences.dart';
import 'package:myoro_player/shared/services/playlist_service/playlist_service.dart';
import 'package:myoro_player/shared/services/song_service/song_service.dart';
import 'package:myoro_player/shared/services/user_preferences_service/user_preferences_service.dart';
import 'package:myoro_player/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:myoro_player/shared/widgets/inputs/underline_input.dart';
import 'package:myoro_player/shared/widgets/scrollbars/vertical_scroll_list.dart';
import 'package:myoro_player/shared/widgets/specific/playlist_listing.dart';

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
          BlocProvider(create: (context) => MainScreenBodySongListBloc()),
          BlocProvider(create: (context) => MainScreenBodyFooterBloc(userPreferencesCubit)),
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
