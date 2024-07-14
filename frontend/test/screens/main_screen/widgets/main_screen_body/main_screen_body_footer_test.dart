import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/main_screen/blocs/main_screen_body_footer_bloc/main_screen_body_footer_bloc.dart';
import 'package:frontend/screens/main_screen/widgets/main_screen_body/main_screen_body_footer.dart';
import 'package:frontend/shared/blocs/user_preferences_cubit.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/design_system/image_design_system.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/models/user_preferences.dart';
import 'package:frontend/shared/services/playlist_service/playlist_service.dart';
import 'package:frontend/shared/services/user_preferences_service/user_preferences_service.dart';
import 'package:frontend/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:frontend/shared/widgets/images/base_image.dart';
import 'package:frontend/shared/widgets/sliders/base_slider.dart';
import 'package:kiwi/kiwi.dart';

import '../../../../base_test_widget.dart';
import '../../../../mocks/playlist_service_mock.dart';
import '../../../../mocks/user_preferences_mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();

  setUp(() {
    kiwiContainer
      ..registerFactory<UserPreferencesService>((_) => UserPreferencesServiceMock.preConfigured())
      ..registerFactory<PlaylistService>((_) => PlaylistServiceMock.preConfigured());
  });
  tearDown(() => kiwiContainer.clear());

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
      BaseTestWidget(
        themeMode: ThemeMode.dark,
        child: MultiBlocProvider(
          providers: [
            BlocProvider(create: (_) => UserPreferencesCubit(UserPreferences.mock)),
            BlocProvider(create: (_) => MainScreenBodyFooterBloc()),
          ],
          child: const MainScreenBodyFooter(),
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
          w.children.length == 2 &&
          w.children.first is Text &&
          (w.children.first as Text).maxLines == 1 &&
          (w.children.first as Text).overflow == TextOverflow.ellipsis &&
          (w.children.first as Text).data == '' &&
          w.children.last is Text &&
          (w.children.last as Text).maxLines == 1 &&
          (w.children.last as Text).overflow == TextOverflow.ellipsis &&
          (w.children.last as Text).data == '')),
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
    expect(tester.takeException(), isInstanceOf<UnimplementedError>());
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.tap(find.byIcon(Icons.skip_next));
    expect(tester.takeException(), isInstanceOf<UnimplementedError>());
    await tester.tap(find.byIcon(Icons.repeat));
    await tester.tap(find.byIcon(Icons.queue_music));
    expect(tester.takeException(), isInstanceOf<UnimplementedError>());
    await tester.drag(
      find.byWidgetPredicate((w) => w is BaseSlider && w.width == 190),
      const Offset(50, 0),
    );
    await tester.drag(
      find.byWidgetPredicate((w) => w is BaseSlider && w.max == 100),
      const Offset(50, 0),
    );
  });
}
