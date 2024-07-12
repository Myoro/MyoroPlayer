import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/main_screen/widgets/main_screen_body/main_screen_body_footer.dart';
import 'package:frontend/shared/controllers/song_controller.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/services/playlist_service/playlist_service.dart';
import 'package:frontend/shared/widgets/buttons/icon_text_hover_button.dart';
import 'package:frontend/shared/widgets/sliders/base_slider.dart';
import 'package:kiwi/kiwi.dart';

import '../../../../base_test_widget.dart';
import '../../../../mocks/playlist_service_mock.dart';

void main() {
  final kiwiContainer = KiwiContainer();

  setUp(() {
    kiwiContainer
      ..registerFactory<PlaylistService>((_) => PlaylistServiceMock.preConfigured())
      ..registerSingleton<SongController>((_) => SongController());
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
      const BaseTestWidget(
        themeMode: ThemeMode.dark,
        child: MainScreenBodyFooter(),
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
          w.children.first is Icon &&
          w.children[1] is SizedBox &&
          (w.children[1] as SizedBox).width == 5 &&
          w.children.last is Expanded &&
          (w.children.last as Expanded).child is Column)),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
          (w) => (w is Icon && w.icon == Icons.music_note && w.size == ImageSizeEnum.small.size + 10 && w.color == DarkModeColorDesignSystem.onBackground)),
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
          (w.children.first as Text).data == 'Song qwenqwi j wioje qwioje qiwej' &&
          w.children.last is Text &&
          (w.children.last as Text).maxLines == 1 &&
          (w.children.last as Text).overflow == TextOverflow.ellipsis &&
          (w.children.last as Text).data == 'asd owqo jwqeoiqwewiqjeoiqwjeqwoij')),
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
          w.children.first is BaseSlider &&
          (w.children.first as BaseSlider).width == 180 &&
          w.children[1] is SizedBox &&
          (w.children[1] as SizedBox).height == 1 &&
          w.children.last is Row)),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (w) => w is Row && w.mainAxisAlignment == MainAxisAlignment.center && w.children.length == 5,
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
      find.byWidgetPredicate((w) => (w is SizedBox &&
          w.child is Row &&
          (w.child as Row).mainAxisAlignment == MainAxisAlignment.end &&
          (w.child as Row).children.length == 2 &&
          (w.child as Row).children.last is BaseSlider)),
      findsOneWidget,
    );
    iconTextHoverButtonPredicate(Icons.queue_music);

    // Testing the buttons
    await tester.tap(find.byIcon(Icons.shuffle));
    expect(tester.takeException(), isInstanceOf<UnimplementedError>());
    await tester.tap(find.byIcon(Icons.skip_previous));
    expect(tester.takeException(), isInstanceOf<UnimplementedError>());
    await tester.tap(find.byIcon(Icons.play_arrow));
    await tester.tap(find.byIcon(Icons.skip_next));
    expect(tester.takeException(), isInstanceOf<UnimplementedError>());
    await tester.tap(find.byIcon(Icons.repeat));
    expect(tester.takeException(), isInstanceOf<UnimplementedError>());
    await tester.tap(find.byIcon(Icons.queue_music));
    expect(tester.takeException(), isInstanceOf<UnimplementedError>());
  });
}
