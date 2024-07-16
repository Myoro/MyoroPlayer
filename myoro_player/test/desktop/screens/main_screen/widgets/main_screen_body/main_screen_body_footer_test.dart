import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_footer_bloc/main_screen_body_footer_bloc.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_footer_bloc/main_screen_body_footer_event.dart';
import 'package:myoro_player/desktop/screens/main_screen/blocs/main_screen_body_footer_bloc/main_screen_body_footer_state.dart';
import 'package:myoro_player/desktop/screens/main_screen/widgets/main_screen_body/main_screen_body_footer.dart';
import 'package:myoro_player/shared/blocs/user_preferences_cubit.dart';
import 'package:myoro_player/shared/design_system/color_design_system.dart';
import 'package:myoro_player/shared/design_system/decoration_design_system.dart';
import 'package:myoro_player/shared/design_system/image_design_system.dart';
import 'package:myoro_player/shared/enums/image_size_enum.dart';
import 'package:myoro_player/shared/models/song.dart';
import 'package:myoro_player/shared/models/user_preferences.dart';
import 'package:myoro_player/shared/services/playlist_service/playlist_service.dart';
import 'package:myoro_player/shared/services/song_service/song_service.dart';
import 'package:myoro_player/shared/services/user_preferences_service/user_preferences_service.dart';
import 'package:myoro_player/shared/widgets/buttons/base_hover_button.dart';
import 'package:myoro_player/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:myoro_player/shared/widgets/images/base_image.dart';
import 'package:myoro_player/shared/widgets/scrollbars/vertical_scrollbar.dart';
import 'package:myoro_player/shared/widgets/sliders/base_slider.dart';
import 'package:kiwi/kiwi.dart';

import '../../../../../base_test_widget.dart';
import '../../../../../mocks/playlist_service_mock.dart';
import '../../../../../mocks/song_service.mock.dart';
import '../../../../../mocks/user_preferences_mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();
  late final UserPreferencesCubit userPreferencesCubit;
  late final MainScreenBodyFooterBloc mainScreenBodyFooterBloc;
  final songOne = Song.mock;
  final songTwo = Song.mock.copyWith(title: 'Another song');

  setUp(() {
    kiwiContainer
      ..registerFactory<UserPreferencesService>((_) => UserPreferencesServiceMock.preConfigured())
      ..registerFactory<PlaylistService>((_) => PlaylistServiceMock.preConfigured())
      ..registerFactory<SongService>((_) => SongServiceMock.preConfigured());

    userPreferencesCubit = UserPreferencesCubit(UserPreferences.mock);
    mainScreenBodyFooterBloc = MainScreenBodyFooterBloc(userPreferencesCubit);
  });

  tearDown(() {
    kiwiContainer.clear();
    userPreferencesCubit.close();
    mainScreenBodyFooterBloc.close();
  });

  void iconTextHoverButtonPredicate(IconData icon) {
    expect(
      find.byWidgetPredicate(
        (w) => w is IconTextHoverButton && w.icon == icon && w.iconSize == ImageSizeEnum.small.size,
      ),
      findsOneWidget,
    );
  }

  testWidgets('MainScreenBodyFooter widget test.', (tester) async {
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider.value(value: userPreferencesCubit),
          BlocProvider.value(value: mainScreenBodyFooterBloc),
        ],
        child: const BaseTestWidget(
          themeMode: ThemeMode.dark,
          child: MainScreenBodyFooter(),
        ),
      ),
    );

    expect(find.byType(MainScreenBodyFooter), findsOneWidget);

    expect(
      find.byWidgetPredicate((w) => (w is Container && w.padding == const EdgeInsets.symmetric(horizontal: 15) && w.child is LayoutBuilder)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => w is Row && w.children.length == 3),
      findsAtLeastNWidgets(1),
    );

    // [_SongInformation]
    expect(
      find.byWidgetPredicate((w) => w is SizedBox && w.child is Row),
      findsAtLeastNWidgets(1),
    );
    expect(
      find.byWidgetPredicate((w) => (w is Row &&
          w.children.length == 3 &&
          w.children.first is BaseImage &&
          w.children[1] is SizedBox &&
          (w.children[1] as SizedBox).width == 5 &&
          w.children.last is Expanded &&
          (w.children.last as Expanded).child is Column)),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate((w) => (w is BaseImage &&
          w.svgPath == ImageDesignSystem.logo &&
          w.svgColor == DarkModeColorDesignSystem.onBackground &&
          w.blob == null &&
          w.size == ImageSizeEnum.small.size + 10)),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate((w) => (w is Column &&
          w.mainAxisAlignment == MainAxisAlignment.center &&
          w.crossAxisAlignment == CrossAxisAlignment.start &&
          w.children.length == 1 &&
          w.children.first is Text &&
          (w.children.first as Text).maxLines == 1 &&
          (w.children.first as Text).overflow == TextOverflow.ellipsis &&
          (w.children.first as Text).data == '')),
      findsOneWidget,
    );

    // [_SongControls]
    expect(
      find.byWidgetPredicate((w) => w is Expanded && w.child is Column),
      findsAtLeastNWidgets(1),
    );
    expect(
      find.byWidgetPredicate((w) => (w is Column &&
          w.mainAxisAlignment == MainAxisAlignment.center &&
          w.children.length == 3 &&
          w.children.first is ValueListenableBuilder<double?> &&
          w.children[1] is SizedBox &&
          (w.children[1] as SizedBox).height == 1 &&
          w.children.last is BlocBuilder<UserPreferencesCubit, UserPreferences>)),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (w) => w is Row && w.mainAxisAlignment == MainAxisAlignment.center && w.children.length == 9,
      ),
      findsOneWidget,
    );
    iconTextHoverButtonPredicate(Icons.shuffle);
    iconTextHoverButtonPredicate(Icons.skip_previous);
    iconTextHoverButtonPredicate(Icons.play_arrow);
    iconTextHoverButtonPredicate(Icons.skip_next);
    iconTextHoverButtonPredicate(Icons.repeat);

    // [_MiscControls]
    expect(
      find.byWidgetPredicate(
        (w) => w is SizedBox && w.child is BlocBuilder<UserPreferencesCubit, UserPreferences>,
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (w) => w is Row && w.mainAxisAlignment == MainAxisAlignment.end && w.children.length == 3 && w.children.last is BaseSlider,
      ),
      findsOneWidget,
    );
    iconTextHoverButtonPredicate(Icons.queue_music);

    // Testing the buttons and sliders
    await tester.tap(find.byIcon(Icons.shuffle));
    await tester.tap(find.byIcon(Icons.skip_previous));
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.tap(find.byIcon(Icons.skip_next));
    await tester.tap(find.byIcon(Icons.repeat));
    await tester.drag(
      find.byWidgetPredicate((w) => w is BaseSlider && w.width == 190),
      const Offset(50, 0),
    );
    await tester.drag(
      find.byWidgetPredicate((w) => w is BaseSlider && w.max == 100),
      const Offset(50, 0),
    );

    // Testing the queue overlay
    mainScreenBodyFooterBloc.add(AddToQueueEvent(songOne));
    mainScreenBodyFooterBloc.add(AddToQueueEvent(songTwo));
    await tester.pump();
    await tester.tap(find.byIcon(Icons.queue_music));
    await tester.pump();
    expect(
      find.byWidgetPredicate((w) => (w is GestureDetector &&
          w.child is Stack &&
          (w.child as Stack).children.length == 2 &&
          (w.child as Stack).children.first is Container &&
          ((w.child as Stack).children.first as Container).color == ColorDesignSystem.transparent &&
          (w.child as Stack).children.last is Positioned)),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate((w) => w is Positioned && w.bottom == 95 && w.child is AnimatedBuilder),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate((w) => w is FadeTransition && w.child is Container),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate((w) =>
          (w is Container &&
              w.decoration ==
                  BoxDecoration(
                    color: DarkModeColorDesignSystem.background,
                    borderRadius: DecorationDesignSystem.borderRadius,
                    border: Border.all(width: 2, color: DarkModeColorDesignSystem.onBackground),
                  )) &&
          w.child is BlocBuilder<MainScreenBodyFooterBloc, MainScreenBodyFooterState>),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate((w) => (w is Material &&
          w.borderRadius == DecorationDesignSystem.borderRadius &&
          w.child is Padding &&
          (w.child as Padding).padding == const EdgeInsets.symmetric(vertical: 5) &&
          (w.child as Padding).child is ValueListenableBuilder<List<Song>>)),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate((w) => w is VerticalScrollbar && w.children.length == 2),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate((w) => (w is Padding &&
          w.child is BaseHoverButton &&
          (w.child as BaseHoverButton).padding ==
              const EdgeInsets.only(
                top: 5,
                bottom: 5,
                left: 8,
                right: 5,
              ))),
      findsNWidgets(2),
    );
    expect(
      find.byWidgetPredicate((w) => (w is Row &&
          w.children.length == 5 &&
          w.children.first is BaseImage &&
          w.children[1] is SizedBox &&
          (w.children[1] as SizedBox).width == 10 &&
          w.children[2] is Expanded &&
          (w.children[2] as Expanded).child is Column &&
          w.children[3] is SizedBox &&
          (w.children[3] as SizedBox).width == 10 &&
          w.children.last is BaseHoverButton &&
          (w.children.last as BaseHoverButton).disableHover)),
      findsNWidgets(2),
    );
    expect(
      find.byWidgetPredicate((w) => (w is BaseImage &&
          w.svgPath == ImageDesignSystem.logo &&
          w.svgColor == DarkModeColorDesignSystem.onBackground &&
          w.size == ImageSizeEnum.small.size + 10)),
      findsNWidgets(3), // This includes [_SongInformation] not in this overlay
    );
    for (final song in [songOne, songTwo]) {
      expect(
        find.byWidgetPredicate((w) => (w is Column &&
            w.mainAxisSize == MainAxisSize.min &&
            w.mainAxisAlignment == MainAxisAlignment.center &&
            w.crossAxisAlignment == CrossAxisAlignment.start &&
            w.children.length == 2 &&
            w.children.first is Text &&
            (w.children.first as Text).data == song.title &&
            (w.children.first as Text).maxLines == 1 &&
            (w.children.first as Text).overflow == TextOverflow.ellipsis &&
            w.children.last is Text &&
            (w.children.last as Text).data == song.artist &&
            (w.children.last as Text).maxLines == 1 &&
            (w.children.last as Text).overflow == TextOverflow.ellipsis)),
        findsOneWidget,
      );
    }
    expect(
      find.byWidgetPredicate((w) => (w is Container &&
          w.decoration ==
              BoxDecoration(
                color: ColorDesignSystem.transparent,
                borderRadius: DecorationDesignSystem.borderRadius,
              ) &&
          w.child is Icon &&
          (w.child as Icon).icon == Icons.arrow_upward &&
          (w.child as Icon).size == ImageSizeEnum.small.size &&
          (w.child as Icon).color == DarkModeColorDesignSystem.onBackground)),
      findsNWidgets(2),
    );
    await tester.tap(find.byIcon(Icons.arrow_upward).last);
    await tester.pump();
    await tester.tap(find.byWidgetPredicate((w) => w is Container && w.color == ColorDesignSystem.transparent));
    await tester.pump();
  });
}
