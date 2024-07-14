import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_footer_bloc/main_screen_body_footer_bloc.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_bloc.dart';
import 'package:frontend/screens/main_screen/enums/main_screen_body_song_list_context_menu_enum.dart';
import 'package:frontend/shared/blocs/user_preferences_cubit.dart';
import 'package:frontend/shared/helpers/file_system_helper.dart';
import 'package:frontend/shared/models/song.dart';
import 'package:frontend/shared/models/user_preferences.dart';
import 'package:frontend/shared/services/playlist_service/playlist_service.dart';
import 'package:frontend/shared/services/song_service/song_service.dart';
import 'package:frontend/shared/widgets/modals/delete_song_modal.dart';
import 'package:kiwi/kiwi.dart';

import '../../../base_test_widget.dart';
import '../../../mocks/file_system_helper_mock.dart';
import '../../../mocks/playlist_service_mock.dart';
import '../../../mocks/song_service.mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();
  final key = UniqueKey();
  final song = Song.mock;

  setUpAll(() {
    kiwiContainer
      ..registerFactory<FileSystemHelper>((_) => FileSystemHelperMock.preConfigured())
      ..registerFactory<PlaylistService>((_) => PlaylistServiceMock.preConfigured())
      ..registerFactory<SongService>((_) => SongServiceMock.preConfigured());
  });

  tearDownAll(() => kiwiContainer.clear());

  final widget = BaseTestWidget(
    child: MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => UserPreferencesCubit(UserPreferences.mock)),
        BlocProvider(create: (context) => MainScreenBodySongListBloc()),
        BlocProvider(create: (context) => MainScreenBodyFooterBloc()),
      ],
      child: Builder(
        builder: (context) {
          return GestureDetector(
            key: key,
            onTap: () {
              MainScreenBodySongListContextMenuEnum.showContextMenu(
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
    for (final value in MainScreenBodySongListContextMenuEnum.values) {
      expect(find.byIcon(value.icon), findsOneWidget);
      expect(find.text(value.text), findsOneWidget);
    }
  }

  testWidgets(
    'MainScreenBodySongListContextMenuEnum.addToQueue widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(MainScreenBodySongListContextMenuEnum.addToQueue.text));
      await tester.pump();
      expect(find.text('${song.title} added to queue.'), findsOneWidget);
    },
  );

  testWidgets(
    'MainScreenBodySongListContextMenuEnum.copySongToPlaylist widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(MainScreenBodySongListContextMenuEnum.copySongToPlaylist.text));
    },
  );

  testWidgets(
    'MainScreenBodySongListContextMenuEnum.addToQueue widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(MainScreenBodySongListContextMenuEnum.moveSongToPlaylist.text));
    },
  );

  testWidgets(
    'MainScreenBodySongListContextMenuEnum.addToQueue widget test.',
    (tester) async {
      await pumpAndDisplayContextMenu(tester);
      expectCalls();
      await tester.tap(find.text(MainScreenBodySongListContextMenuEnum.deleteSong.text));
      await tester.pump();
      expect(find.byType(DeleteSongModal), findsOneWidget);
    },
  );
}
