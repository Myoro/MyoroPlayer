import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/shared/blocs/model_resolver_bloc/model_resolver_bloc.dart';
import 'package:frontend/shared/controllers/model_resolver_controller.dart';
import 'package:frontend/shared/models/playlist.dart';
import 'package:frontend/shared/services/playlist_service/playlist_service.dart';
import 'package:frontend/shared/widgets/inputs/outline_input.dart';
import 'package:frontend/shared/widgets/modals/rename_playlist_modal.dart';
import 'package:kiwi/kiwi.dart';

import '../../../base_test_widget.dart';
import '../../../mocks/playlist_service_mock.dart';

void main() {
  const key = Key('');
  final kiwiContainer = KiwiContainer();
  final modelResolverController = ModelResolverController<List<Playlist>>();
  final modelResolverBloc = ModelResolverBloc<List<Playlist>>();

  setUpAll(() {
    kiwiContainer.registerFactory<PlaylistService>((_) => PlaylistServiceMock.preConfigured());
    modelResolverController.bloc = modelResolverBloc;
    modelResolverController.request = () async => PlaylistServiceMock.preConfiguredPlaylists;
  });

  tearDownAll(() {
    kiwiContainer.clear();
    modelResolverBloc.close();
  });

  Widget widget = BaseTestWidget(
    child: Builder(
      builder: (context) {
        return GestureDetector(
          key: key,
          onTap: () {
            RenamePlaylistModal.show(
              context,
              PlaylistServiceMock.preConfiguredPlaylist,
              modelResolverController,
            );
          },
        );
      },
    ),
  );

  Future<void> expectCalls(WidgetTester tester) async {
    await tester.tap(find.byKey(key));
    await tester.pump();

    expect(find.byType(RenamePlaylistModal), findsOneWidget);
    expect(
      find.byWidgetPredicate(
        (w) => w is Column && w.children.length == 1 && w.children.first is OutlineInput,
      ),
      findsOneWidget,
    );
  }

  testWidgets('RenamePlaylistModal empty input error case widget test.', (tester) async {
    await tester.pumpWidget(widget);
    await expectCalls(tester);
    await tester.tap(find.text('Confirm'));
    await tester.pump();
    expect(find.text('Name cannot be empty'), findsOneWidget);
  });

  testWidgets('RenamePlaylistModal invalid character error case widget test.', (tester) async {
    await tester.pumpWidget(widget);
    await expectCalls(tester);
    await tester.enterText(find.byType(OutlineInput), '**//\\');
    await tester.tap(find.text('Confirm'));
    await tester.pump();
    expect(find.text('Cannot contains the characters: /\\:*?"<>|'), findsOneWidget);
  });

  testWidgets('RenamePlaylistModal success case widget test.', (tester) async {
    await tester.pumpWidget(widget);
    await expectCalls(tester);
    await tester.enterText(find.byType(OutlineInput), 'Test');
    await tester.tap(find.text('Confirm'));
  });
}
