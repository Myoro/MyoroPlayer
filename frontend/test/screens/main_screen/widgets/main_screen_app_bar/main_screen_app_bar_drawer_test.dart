import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_playlist_side_bar_bloc/main_screen_body_playlist_side_bar_bloc.dart';
import 'package:frontend/screens/main_screen/enums/main_screen_app_bar_drawer_items_enum.dart';
import 'package:frontend/screens/main_screen/widgets/main_screen_app_bar/main_screen_app_bar_drawer.dart';
import 'package:frontend/shared/blocs/user_preferences_cubit.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/helpers/device_helper.dart';
import 'package:frontend/shared/helpers/file_system_helper.dart';
import 'package:frontend/shared/models/user_preferences.dart';
import 'package:frontend/shared/services/playlist_service/playlist_service.dart';
import 'package:frontend/shared/services/user_preferences_service/user_preferences_service.dart';
import 'package:frontend/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:frontend/shared/widgets/scrollbars/vertical_scrollbar.dart';
import 'package:kiwi/kiwi.dart';

import '../../../../base_test_widget.dart';
import '../../../../mocks/device_helper_mock.dart';
import '../../../../mocks/file_system_helper_mock.dart';
import '../../../../mocks/playlist_service_mock.dart';
import '../../../../mocks/user_preferences_mock.dart';

void main() {
  const key = Key('');
  final kiwiContainer = KiwiContainer();
  late final UserPreferencesCubit userPreferencesCubit;
  late final MainScreenBodyPlaylistSideBarBloc mainScreenBodyPlaylistSideBarBloc;

  setUpAll(() {
    kiwiContainer
      ..registerFactory<DeviceHelper>((_) => DeviceHelperMock())
      ..registerFactory<FileSystemHelper>((_) => FileSystemHelperMock.preConfigured())
      ..registerFactory<UserPreferencesService>((_) => UserPreferencesServiceMock.preConfigured())
      ..registerFactory<PlaylistService>((_) => PlaylistServiceMock.preConfigured());

    userPreferencesCubit = UserPreferencesCubit(UserPreferences.mock);
    mainScreenBodyPlaylistSideBarBloc = MainScreenBodyPlaylistSideBarBloc();
  });

  tearDownAll(() {
    kiwiContainer.clear();
    userPreferencesCubit.close();
    mainScreenBodyPlaylistSideBarBloc.close();
  });

  final Widget widget = BaseTestWidget(
    child: Builder(
      builder: (context) {
        return GestureDetector(
          key: key,
          onTap: () {
            MainScreenAppBarDrawer.show(context);
          },
        );
      },
    ),
  );

  Future<void> expectCalls(WidgetTester tester) async {
    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle();

    expect(find.byType(MainScreenAppBarDrawer), findsOneWidget);

    expect(
      find.byWidgetPredicate((w) =>
          (w is Expanded && w.child is VerticalScrollbar && (w.child as VerticalScrollbar).children.length == MainScreenAppBarDrawerItemsEnum.values.length)),
      findsOneWidget,
    );

    for (final value in MainScreenAppBarDrawerItemsEnum.values) {
      expect(
        find.byWidgetPredicate((w) => (w is IconTextHoverButton &&
            w.icon == value.icon &&
            w.iconSize == ImageSizeEnum.small.size &&
            w.text == value.text &&
            w.padding == const EdgeInsets.all(5))),
        findsOneWidget,
      );
    }
  }

  testWidgets('MainScreenAppBarDrawer close button widget test.', (tester) async {
    await tester.pumpWidget(widget);
    await expectCalls(tester);
    await tester.tap(find.byIcon(Icons.arrow_right));
  });

  testWidgets('MainScreenAppBarDrawerItemsEnum.openPlaylist button widget test.', (tester) async {
    await tester.pumpWidget(
      BlocProvider.value(
        value: mainScreenBodyPlaylistSideBarBloc,
        child: widget,
      ),
    );
    await expectCalls(tester);
    await tester.tap(find.text(MainScreenAppBarDrawerItemsEnum.openPlaylist.text));
  });

  testWidgets('MainScreenAppBarDrawerItemsEnum.createPlaylist button widget test.', (tester) async {
    await tester.pumpWidget(
      BlocProvider.value(
        value: mainScreenBodyPlaylistSideBarBloc,
        child: widget,
      ),
    );
    await expectCalls(tester);
    await tester.tap(find.text(MainScreenAppBarDrawerItemsEnum.createPlaylist.text));
  });

  testWidgets('MainScreenAppBarDrawerItemsEnum.toggleTheme button widget test.', (tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: userPreferencesCubit),
          BlocProvider.value(value: mainScreenBodyPlaylistSideBarBloc),
        ],
        child: widget,
      ),
    );
    await expectCalls(tester);
    await tester.tap(find.text(MainScreenAppBarDrawerItemsEnum.toggleTheme.text));
  });

  testWidgets('MainScreenAppBarDrawerItemsEnum.quit button widget test.', (tester) async {
    await tester.pumpWidget(
      BlocProvider.value(
        value: mainScreenBodyPlaylistSideBarBloc,
        child: widget,
      ),
    );
    await expectCalls(tester);
    await tester.tap(find.text(MainScreenAppBarDrawerItemsEnum.quit.text));
  });
}
