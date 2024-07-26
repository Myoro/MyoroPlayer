import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:myoro_player/core/helpers/file_system_helper.dart';
import 'package:myoro_player/core/services/playlist_service/playlist_service.dart';
import 'package:myoro_player/mobile/screens/main_screen/widgets/main_screen_app_bar/main_screen_app_bar_playlist_drawer.dart';
import 'package:myoro_player/shared/blocs/playlist_listing_bloc/playlist_listing_bloc.dart';
import 'package:myoro_player/shared/screens/main_screen/playlist_listing.dart';

import '../../../../../base_test_widget.dart';
import '../../../../../mocks/file_system_helper_mock.dart';
import '../../../../../mocks/playlist_service_mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();

  setUp(() {
    kiwiContainer
      ..registerFactory<FileSystemHelper>((_) => FileSystemHelperMock.preConfigured())
      ..registerFactory<PlaylistService>((_) => PlaylistServiceMock.preConfigured());
  });

  tearDown(() => kiwiContainer.clear());

  testWidgets('MainScreenAppBarPlaylistDrawer widget test.', (tester) async {
    await tester.pumpWidget(
      BlocProvider(
        create: (_) => PlaylistListingBloc(),
        child: BaseTestWidget(
          child: Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () => MainScreenAppBarPlaylistDrawer.show(
                  context,
                ),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();

    expect(find.byType(PlaylistListing), findsOneWidget);
  });
}
