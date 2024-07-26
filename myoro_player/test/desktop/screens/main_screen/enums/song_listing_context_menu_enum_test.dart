import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/core/enums/platform_enum.dart';
import 'package:myoro_player/core/helpers/platform_helper.dart';
import 'package:myoro_player/shared/blocs/song_controls_bloc/song_controls_bloc.dart';
import 'package:myoro_player/shared/blocs/song_listing_bloc/song_listing_bloc.dart';
import 'package:myoro_player/desktop/screens/main_screen/enums/song_listing_context_menu_enum.dart';
import 'package:myoro_player/shared/blocs/user_preferences_cubit.dart';
import 'package:myoro_player/core/helpers/file_system_helper.dart';
import 'package:myoro_player/core/models/song.dart';
import 'package:myoro_player/core/models/user_preferences.dart';
import 'package:myoro_player/core/services/playlist_service/playlist_service.dart';
import 'package:myoro_player/core/services/song_service/song_service.dart';
import 'package:myoro_player/core/services/user_preferences_service/user_preferences_service.dart';
import 'package:myoro_player/core/widgets/modals/delete_song_modal.dart';
import 'package:kiwi/kiwi.dart';

import '../../../../base_test_widget.dart';
import '../../../../mocks/file_system_helper_mock.dart';
import '../../../../mocks/platform_helper_mock.dart';
import '../../../../mocks/playlist_service_mock.dart';
import '../../../../mocks/song_service.mock.dart';
import '../../../../mocks/user_preferences_mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();
  late final UserPreferencesCubit userPreferencesCubit;
  final key = UniqueKey();
  final song = Song.mock;

  setUpAll(() {
    kiwiContainer
      ..registerFactory<UserPreferencesService>((_) => UserPreferencesServiceMock.preConfigured())
      ..registerFactory<FileSystemHelper>((_) => FileSystemHelperMock.preConfigured())
      ..registerFactory<PlaylistService>((_) => PlaylistServiceMock.preConfigured())
      ..registerFactory<SongService>((_) => SongServiceMock.preConfigured())
      ..registerFactory<PlatformHelper>((_) => PlatformHelperMock.preConfigured(platform: PlatformEnum.windows));

    userPreferencesCubit = UserPreferencesCubit(UserPreferences.mock);
  });

  tearDownAll(() {
    kiwiContainer.clear();
    userPreferencesCubit.close();
  });

  final widget = BaseTestWidget(
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => userPreferencesCubit),
        BlocProvider(create: (context) => SongListingBloc()),
        BlocProvider(create: (context) => SongControlsBloc(userPreferencesCubit)),
      ],
      child: Builder(
        builder: (context) {
          return GestureDetector(
            key: key,
            onTap: () {
              SongListingContextMenuEnum.showContextMenu(
                context,
                TapDownDetails(),
                song,
              );
            },
          );
        },
      ),
    ),
  );

  Future<void> pumpAndDisplayContextMenu(WidgetTester tester) async {
    await tester.pumpWidget(widget);
    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle();
  }

  void expectCalls() {
    for (final value in SongListingContextMenuEnum.values) {
      expect(find.byIcon(value.icon), findsOneWidget);
      expect(find.text(value.text), findsOneWidget);
    }
  }

  testWidgets(
    'SongListingContextMenuEnum.addToQueue widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(SongListingContextMenuEnum.addToQueue.text));
      await tester.pump();
      expect(find.text('${song.title} added to queue.'), findsOneWidget);
    },
  );

  testWidgets(
    'SongListingContextMenuEnum.copySongToPlaylist widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(SongListingContextMenuEnum.copySongToPlaylist.text));
    },
  );

  testWidgets(
    'SongListingContextMenuEnum.addToQueue widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(SongListingContextMenuEnum.moveSongToPlaylist.text));
    },
  );

  testWidgets(
    'SongListingContextMenuEnum.addToQueue widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(SongListingContextMenuEnum.deleteSong.text));
      await tester.pump();
      expect(find.byType(DeleteSongModal), findsOneWidget);
    },
  );
}
