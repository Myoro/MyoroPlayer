import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/shared/widgets/screens/main_screen/main_screen_app_bar_options_drawer.dart';
import 'package:myoro_player/shared/blocs/playlist_listing_bloc/playlist_listing_bloc.dart';
import 'package:myoro_player/shared/enums/main_screen_app_bar_options_drawer_items_enum.dart';
import 'package:myoro_player/shared/blocs/user_preferences_cubit.dart';
import 'package:myoro_player/core/enums/image_size_enum.dart';
import 'package:myoro_player/core/helpers/device_helper.dart';
import 'package:myoro_player/core/helpers/file_system_helper.dart';
import 'package:myoro_player/core/models/user_preferences.dart';
import 'package:myoro_player/core/services/playlist_service/playlist_service.dart';
import 'package:myoro_player/core/services/user_preferences_service/user_preferences_service.dart';
import 'package:myoro_player/core/widgets/buttons/icon_text_hover_button.dart';
import 'package:myoro_player/core/widgets/scrollbars/vertical_scroll_list.dart';
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
  late final PlaylistListingBloc mainScreenBodyPlaylistSideBarBloc;

  setUpAll(() {
    kiwiContainer
      ..registerFactory<DeviceHelper>((_) => DeviceHelperMock())
      ..registerFactory<FileSystemHelper>((_) => FileSystemHelperMock.preConfigured())
      ..registerFactory<UserPreferencesService>((_) => UserPreferencesServiceMock.preConfigured())
      ..registerFactory<PlaylistService>((_) => PlaylistServiceMock.preConfigured());

    userPreferencesCubit = UserPreferencesCubit(UserPreferences.mock);
    mainScreenBodyPlaylistSideBarBloc = PlaylistListingBloc();
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
            MainScreenAppBarOptionsDrawer.show(context);
          },
        );
      },
    ),
  );

  Future<void> expectCalls(WidgetTester tester) async {
    await tester.tap(find.byKey(key));
    await tester.pumpAndSettle();

    expect(find.byType(MainScreenAppBarOptionsDrawer), findsOneWidget);

    expect(
      find.byWidgetPredicate((w) => (w is Expanded &&
          w.child is VerticalScrollList &&
          (w.child as VerticalScrollList).children.length == MainScreenAppBarOptionsDrawerItemsEnum.values.length)),
      findsOneWidget,
    );

    for (final value in MainScreenAppBarOptionsDrawerItemsEnum.values) {
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

  testWidgets('MainScreenAppBarOptionsDrawer close button widget test.', (tester) async {
    await tester.pumpWidget(widget);
    await expectCalls(tester);
    await tester.tap(find.byIcon(Icons.arrow_right));
  });

  testWidgets('MainScreenAppBarOptionsDrawerItemsEnum.openPlaylist button widget test.', (tester) async {
    await tester.pumpWidget(
      BlocProvider.value(
        value: mainScreenBodyPlaylistSideBarBloc,
        child: widget,
      ),
    );
    await expectCalls(tester);
    await tester.tap(find.text(MainScreenAppBarOptionsDrawerItemsEnum.openPlaylist.text));
  });

  testWidgets('MainScreenAppBarOptionsDrawerItemsEnum.createPlaylist button widget test.', (tester) async {
    await tester.pumpWidget(
      BlocProvider.value(
        value: mainScreenBodyPlaylistSideBarBloc,
        child: widget,
      ),
    );
    await expectCalls(tester);
    await tester.tap(find.text(MainScreenAppBarOptionsDrawerItemsEnum.createPlaylist.text));
  });

  testWidgets('MainScreenAppBarOptionsDrawerItemsEnum.toggleTheme button widget test.', (tester) async {
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
    await tester.tap(find.text(MainScreenAppBarOptionsDrawerItemsEnum.toggleTheme.text));
  });

  testWidgets('MainScreenAppBarOptionsDrawerItemsEnum.quit button widget test.', (tester) async {
    await tester.pumpWidget(
      BlocProvider.value(
        value: mainScreenBodyPlaylistSideBarBloc,
        child: widget,
      ),
    );
    await expectCalls(tester);
    await tester.tap(find.text(MainScreenAppBarOptionsDrawerItemsEnum.quit.text));
  });
}
