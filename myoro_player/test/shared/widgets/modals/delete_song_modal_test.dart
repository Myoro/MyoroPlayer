import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_bloc.dart';
import 'package:myoro_player/screens/main_screen/blocs/main_screen_body_song_list_bloc/main_screen_body_song_list_event.dart';
import 'package:myoro_player/shared/helpers/file_system_helper.dart';
import 'package:myoro_player/shared/models/playlist.dart';
import 'package:myoro_player/shared/models/song.dart';
import 'package:myoro_player/shared/services/song_service/song_service.dart';
import 'package:myoro_player/shared/widgets/modals/base_modal.dart';
import 'package:myoro_player/shared/widgets/modals/delete_song_modal.dart';
import 'package:kiwi/kiwi.dart';

import '../../../base_test_widget.dart';
import '../../../mocks/file_system_helper_mock.dart';
import '../../../mocks/song_service.mock.dart';

void main() {
  final key = UniqueKey();
  final song = Song.mock;
  final kiwiContainer = KiwiContainer();

  setUp(() {
    kiwiContainer
      ..registerFactory<FileSystemHelper>((_) => FileSystemHelperMock.preConfigured())
      ..registerFactory<SongService>((_) => SongServiceMock.preConfigured());
  });

  tearDown(() => kiwiContainer.clear());

  testWidgets('DeleteSongModal widget test.', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        child: BlocProvider(
          create: (context) => MainScreenBodySongListBloc()
            ..add(
              LoadPlaylistSongsEvent(Playlist.mock),
            ),
          child: Builder(
            builder: (context) {
              return GestureDetector(
                key: key,
                onTap: () {
                  DeleteSongModal.show(
                    context,
                    song,
                  );
                },
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byKey(key));
    await tester.pump();

    expect(find.byType(DeleteSongModal), findsOneWidget);
    expect(find.byType(BaseModal<Null>), findsOneWidget);
    expect(find.text('Are you sure you want to delete ${song.title}? This is not reversible!'), findsOneWidget);

    await tester.tap(find.text('Confirm'));
  });
}
