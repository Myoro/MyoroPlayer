import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/desktop/main_screen/widgets/main_screen_body/main_screen_body_song_list.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/widgets/buttons/base_hover_button.dart';
import 'package:frontend/shared/widgets/scrollbars/vertical_scrollbar.dart';
import 'package:frontend/shared/widgets/titles/underline_title.dart';

import '../../../../base_test_widget.dart';

void main() {
  testWidgets('MainScreenBodySongList Widget Test', (tester) async {
    await tester.pumpWidget(
      const BaseTestWidget(
        themeMode: ThemeMode.dark,
        child: Column(
          children: [
            MainScreenBodySongList(),
          ],
        ),
      ),
    );

    expect(find.byType(MainScreenBodySongList), findsOneWidget);

    expect(
      find.byWidgetPredicate((w) => w is Expanded && w.child is Column),
      findsAtLeastNWidgets(1),
    );

    expect(
      find.byWidgetPredicate((w) => (w is Column &&
          w.mainAxisSize == MainAxisSize.min &&
          w.children.length == 2 &&
          w.children.first is UnderlineTitle &&
          (w.children.first as UnderlineTitle).text == '<Playlist Name>' &&
          w.children.last is Expanded)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate((w) => w is Expanded && w.child is VerticalScrollbar),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (w) => w is VerticalScrollbar && w.children.length == 50 * 2 + 1 && w.children.last is SizedBox && (w.children.last as SizedBox).height == 5,
      ),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (w) => w is BaseHoverButton && w.padding == const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      ),
      findsNWidgets(50),
    );

    expect(
      find.byWidgetPredicate((w) => (w is Row &&
          w.children.length == 7 &&
          w.children.first is Icon &&
          w.children[1] is SizedBox &&
          (w.children[1] as SizedBox).width == 10 &&
          w.children[2] is Expanded &&
          w.children[3] is SizedBox &&
          (w.children[3] as SizedBox).width == 10 &&
          w.children[4] is Expanded &&
          w.children[5] is SizedBox &&
          (w.children[5] as SizedBox).width == 10 &&
          w.children.last is Text)),
      findsNWidgets(50),
    );

    expect(
      find.byWidgetPredicate(
          (w) => w is Icon && w.icon == Icons.music_note && w.size == ImageSizeEnum.small.size && w.color == DarkModeColorDesignSystem.onBackground),
      findsNWidgets(50),
    );

    expect(
      find.byWidgetPredicate((w) => w is Expanded && w.child is Column),
      findsAtLeastNWidgets(50),
    );

    expect(
      find.byWidgetPredicate((w) => (w is Column &&
          w.crossAxisAlignment == CrossAxisAlignment.start &&
          w.children.length == 2 &&
          w.children.first is Text &&
          (w.children.first as Text).data == 'Songqowuiejqwoiejqwoiejqwoiejqoiejwqeioj title' &&
          (w.children.first as Text).maxLines == 1 &&
          (w.children.first as Text).overflow == TextOverflow.ellipsis &&
          w.children.last is Text &&
          (w.children.last as Text).data == 'Song aqwpiejqwoiejqwoiejqwoiejqwoiejrtist' &&
          (w.children.last as Text).maxLines == 1 &&
          (w.children.last as Text).overflow == TextOverflow.ellipsis)),
      findsNWidgets(50),
    );

    expect(
      find.byWidgetPredicate((w) => (w is Expanded &&
          w.child is Text &&
          (w.child as Text).data == 'Song albuqjweoiqwjeioqjeoqiwjeoqiwjeioqwem' &&
          (w.child as Text).textAlign == TextAlign.center &&
          (w.child as Text).maxLines == 1 &&
          (w.child as Text).overflow == TextOverflow.ellipsis)),
      findsNWidgets(50),
    );

    expect(
      find.byWidgetPredicate(
        (w) => w is Text && w.data == '420:00' && w.textAlign == TextAlign.center,
      ),
      findsNWidgets(50),
    );
  });
}
