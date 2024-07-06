import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_bloc.dart';
import 'package:frontend/shared/blocs/model_resolver_bloc/model_resolver_bloc.dart';
import 'package:frontend/shared/controllers/model_resolver_controller.dart';
import 'package:frontend/shared/helpers/file_system_helper.dart';
import 'package:frontend/shared/models/playlist.dart';
import 'package:frontend/shared/services/playlist_service/playlist_service.dart';
import 'package:frontend/shared/widgets/modals/base_modal.dart';
import 'package:frontend/shared/widgets/modals/delete_playlist_from_device_confirmation_modal.dart';
import 'package:kiwi/kiwi.dart';
import 'package:mocktail/mocktail.dart';

import '../../../base_test_widget.dart';
import '../../../mocks/file_system_helper_mock.dart';
import '../../../mocks/playlist_service_mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();
  final PlaylistService playlistServiceMock = PlaylistServiceMock();
  late final MainScreenBodyPlaylistSideBarBloc mainScreenBodyPlaylistSideBarBloc;
  final playlistResolver = ModelResolverController<List<Playlist>>();
  final key = UniqueKey();
  final playlist = Playlist.mock;

  setUpAll(() {
    kiwiContainer
      ..registerFactory<FileSystemHelper>((_) => FileSystemHelperMock.preConfigured())
      ..registerFactory<PlaylistService>((_) => playlistServiceMock);

    playlistResolver.bloc = ModelResolverBloc<List<Playlist>>();
    playlistResolver.request = () async => [Playlist.mock];

    mainScreenBodyPlaylistSideBarBloc = MainScreenBodyPlaylistSideBarBloc();
  });

  tearDownAll(() {
    kiwiContainer.clear();
    mainScreenBodyPlaylistSideBarBloc.close();
  });

  Widget widget() {
    return BaseTestWidget(
      child: BlocProvider.value(
        value: mainScreenBodyPlaylistSideBarBloc,
        child: Builder(
          builder: (context) {
            return GestureDetector(
              key: key,
              onTap: () {
                DeletePlaylistFromDeviceConfirmationModal.show(
                  context,
                  playlist: playlist,
                  playlistResolverController: playlistResolver,
                );
              },
            );
          },
        ),
      ),
    );
  }

  void expectCalls() {
    expect(find.byType(DeletePlaylistFromDeviceConfirmationModal), findsOneWidget);
    expect(find.byType(BaseModal), findsOneWidget);
    expect(find.text('Delete ${playlist.name} from device'), findsOneWidget);
    expect(find.text('Are you sure you want to delete ${playlist.name}? This is not reversible!'), findsOneWidget);
  }

  testWidgets('DeletePlaylistFromDeviceConfirmationModal error case widget test.', (tester) async {
    await tester.pumpWidget(widget());
    await tester.tap(find.byKey(key));
    await tester.pump();
    expectCalls();
    await tester.tap(find.text('Confirm'));
  });

  testWidgets('DeletePlaylistFromDeviceConfirmationModal success case widget test.', (tester) async {
    await tester.pumpWidget(widget());
    await tester.tap(find.byKey(key));
    await tester.pump();
    expectCalls();
    when(() => playlistServiceMock.delete(id: any(named: 'id'))).thenAnswer((_) async {});
    await tester.tap(find.text('Confirm'));
  });
}
