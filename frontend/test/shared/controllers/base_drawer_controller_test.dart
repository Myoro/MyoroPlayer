import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kiwi/kiwi.dart';
import 'package:frontend/main.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_bloc.dart';
import 'package:frontend/shared/blocs/user_preferences_cubit.dart';
import 'package:frontend/shared/helpers/file_system_helper.dart';
import 'package:frontend/shared/helpers/snack_bar_helper.dart';
import 'package:frontend/shared/models/user_preferences.dart';
import 'package:frontend/shared/services/playlist_service/playlist_service.dart';
import 'package:frontend/shared/services/user_preferences_service/user_preferences_service.dart';
import 'package:frontend/shared/widgets/drawers/base_drawer.dart';

import '../../mocks/playlist_service_mock.dart';
import '../../mocks/user_preferences_mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();

  setUp(() {
    kiwiContainer
      ..registerFactory<SnackBarHelper>((_) => SnackBarHelper())
      ..registerFactory<FileSystemHelper>((_) => FileSystemHelper())
      ..registerFactory<UserPreferencesService>((_) => UserPreferencesServiceMock.preConfigured())
      ..registerFactory<PlaylistService>((_) => PlaylistServiceMock.preConfigured());
  });

  tearDown(() => kiwiContainer.clear());

  testWidgets('BaseControllerDrawer Test', (tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => UserPreferencesCubit(UserPreferences.mock)),
          BlocProvider(create: (context) => MainScreenBodyPlaylistSideBarBloc()),
        ],
        child: const App(),
      ),
    );

    await tester.tap(find.byIcon(Icons.menu));
    await tester.pump();

    expect(find.byType(BaseDrawer), findsOneWidget);

    await tester.tap(find.byKey(const Key('BaseDrawer close button')), warnIfMissed: false);
    await tester.pump();
  });
}
