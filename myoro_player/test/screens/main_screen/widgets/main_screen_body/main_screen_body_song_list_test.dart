import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/screens/main_screen/blocs/main_screen_body_footer_bloc/main_screen_body_footer_bloc.dart';
import 'package:myoro_player/screens/main_screen/blocs/main_screen_body_footer_bloc/main_screen_body_footer_state.dart';
import 'package:myoro_player/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_bloc.dart';
import 'package:myoro_player/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_event.dart';
import 'package:myoro_player/screens/main_screen/enums/main_screen_body_song_list_context_menu_enum.dart';
import 'package:myoro_player/screens/main_screen/widgets/main_screen_body/main_screen_body_song_list.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/design_system/image_design_system.dart';
import 'package:myoro_player/shared/enums/image_size_enum.dart';
import 'package:myoro_player/shared/extensions/duration_extension.dart';
import 'package:myoro_player/shared/helpers/file_system_helper.dart';
import 'package:myoro_player/shared/models/playlist.dart';
import 'package:myoro_player/shared/models/song.dart';
import 'package:myoro_player/shared/services/playlist_service/playlist_service.dart';
import 'package:myoro_player/shared/services/song_service/song_service.dart';
import 'package:myoro_player/shared/widgets/buttons/base_hover_button.dart';
import 'package:myoro_player/shared/widgets/headers/underline_header.dart';
import 'package:myoro_player/shared/widgets/images/base_image.dart';
import 'package:myoro_player/shared/widgets/scrollbars/vertical_scrollbar.dart';
import 'package:kiwi/kiwi.dart';

import '../../../../base_test_widget.dart';
import '../../../../mocks/file_system_helper_mock.dart';
import '../../../../mocks/playlist_service_mock.dart';
import '../../../../mocks/song_service.mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();
  final playlist = Playlist.mock;
  final songList = Song.mockList(2);

  setUp(() {
    kiwiContainer
      ..registerFactory<FileSystemHelper>((_) => FileSystemHelperMock.preConfigured(songList: songList))
      ..registerFactory<PlaylistService>((_) => PlaylistServiceMock.preConfigured())
      ..registerFactory<SongService>((_) => SongServiceMock.preConfigured());
  });

  tearDown(() => kiwiContainer.clear());

  testWidgets('MainScreenBodySongList widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        themeMode: ThemeMode.dark,
        child: Column(
          children: [
            MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => MainScreenBodySongListBloc()..add(LoadPlaylistSongsEvent(playlist))),
                BlocProvider(create: (context) => MainScreenBodyFooterBloc()),
              ],
              child: const MainScreenBodySongList(),
            ),
          ],
        ),
      ),
    );

    await tester.pump(); // Allow [MainScreenBodySongListBloc] to load the injected songs

    expect(find.byType(MainScreenBodySongList), findsOneWidget);

    expect(
      find.byWidgetPredicate((w) => (w is Column &&
          w.children.length == 2 &&
          w.children.first is UnderlineHeader &&
          (w.children.first as UnderlineHeader).header == playlist.name &&
          w.children.last is BlocBuilder<MainScreenBodyFooterBloc, MainScreenBodyFooterState>)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (w) => w is Expanded && (w).child is VerticalScrollbar && ((w).child as VerticalScrollbar).children.length == songList.length,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (w) => w is Padding && w.padding == const EdgeInsets.only(top: 5, bottom: 0),
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (w) => w is Padding && w.padding == const EdgeInsets.only(top: 5, bottom: 5),
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (w) =>
            w is BaseHoverButton &&
            w.padding ==
                const EdgeInsets.only(
                  top: 5,
                  bottom: 5,
                  left: 8,
                  right: 5,
                ),
      ),
      findsNWidgets(songList.length),
    );
    expect(
      find.byWidgetPredicate((w) => (w is Row &&
          w.children.length == 7 &&
          w.children.first is BaseImage &&
          w.children[1] is SizedBox &&
          (w.children[1] as SizedBox).width == 10 &&
          w.children[2] is Expanded &&
          (w.children[2] as Expanded).child is Column &&
          w.children[3] is SizedBox &&
          (w.children[3] as SizedBox).width == 10 &&
          w.children[4] is Expanded &&
          (w.children[4] as Expanded).child is Text &&
          w.children[5] is SizedBox &&
          (w.children[5] as SizedBox).width == 10 &&
          w.children.last is Text)),
      findsNWidgets(songList.length),
    );
    expect(
      find.byWidgetPredicate((w) => (w is BaseImage &&
          w.svgPath == ImageDesignSystem.logo &&
          w.svgColor == DarkModeColorDesignSystem.onBackground &&
          w.size == ImageSizeEnum.small.size + 10)),
      findsNWidgets(songList.length),
    );
    for (final song in songList) {
      expect(
        find.byWidgetPredicate((w) => (w is Column &&
            w.crossAxisAlignment == CrossAxisAlignment.start &&
            w.children.length == 2 &&
            w.children.first is Text &&
            (w.children.first as Text).maxLines == 1 &&
            (w.children.first as Text).overflow == TextOverflow.ellipsis &&
            (w.children.first as Text).data == song.title &&
            w.children.last is Text &&
            (w.children.last as Text).maxLines == 1 &&
            (w.children.last as Text).overflow == TextOverflow.ellipsis &&
            (w.children.last as Text).data == song.artist)),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate(
          (w) => w is Text && w.maxLines == 1 && w.overflow == TextOverflow.ellipsis && w.data == song.album,
        ),
        findsOneWidget,
      );
      expect(
        find.byWidgetPredicate((w) => w is Text && w.data == song.duration.hhMmSsFormat),
        findsOneWidget,
      );
    }

    final songButtonFinder = find.byType(BaseHoverButton).first;

    /// Playing a song
    await tester.tap(songButtonFinder);

    /// Song context menu
    await tester.tap(find.byType(BaseHoverButton).first, buttons: kSecondaryButton);
    await tester.pump();
    for (final value in MainScreenBodySongListContextMenuEnum.values) {
      expect(find.byIcon(value.icon), findsOneWidget);
      expect(find.text(value.text), findsOneWidget);
    }
  });
}
