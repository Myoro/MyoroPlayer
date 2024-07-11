import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_bloc.dart';
import 'package:frontend/shared/services/song_service/song_service.dart';
import 'package:kiwi/kiwi.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_bloc.dart';
import 'package:frontend/screens/main_screen/widgets/main_screen_body/main_screen_body.dart';
import 'package:frontend/screens/main_screen/widgets/main_screen_body/main_screen_body_footer.dart';
import 'package:frontend/screens/main_screen/widgets/main_screen_body/main_screen_body_playlist_side_bar.dart';
import 'package:frontend/screens/main_screen/widgets/main_screen_body/main_screen_body_song_list.dart';
import 'package:frontend/shared/helpers/file_system_helper.dart';
import 'package:frontend/shared/services/playlist_service/playlist_service.dart';
import 'package:frontend/shared/widgets/dividers/basic_divider.dart';

import '../../../../base_test_widget.dart';
import '../../../../mocks/file_system_helper_mock.dart';
import '../../../../mocks/playlist_service_mock.dart';
import '../../../../mocks/song_service.mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();

  setUp(() {
    kiwiContainer
      ..registerFactory<FileSystemHelper>((_) => FileSystemHelperMock())
      ..registerFactory<PlaylistService>((_) => PlaylistServiceMock.preConfigured())
      ..registerFactory<SongService>((_) => SongServiceMock.preConfigured());
  });

  tearDown(() => kiwiContainer.clear());

  testWidgets('MainScreenBody widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (context) => MainScreenBodyPlaylistSideBarBloc()),
            BlocProvider(create: (context) => MainScreenBodySongListBloc()),
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
