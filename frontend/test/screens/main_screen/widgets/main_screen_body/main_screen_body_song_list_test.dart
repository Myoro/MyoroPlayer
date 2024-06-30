import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/screens/main_screen/widgets/main_screen_body/main_screen_body_song_list.dart';
import 'package:frontend/shared/design_system/color_design_system.dart';
import 'package:frontend/shared/enums/image_size_enum.dart';
import 'package:frontend/shared/widgets/buttons/base_hover_button.dart';
import 'package:frontend/shared/widgets/headers/underline_header.dart';
import 'package:frontend/shared/widgets/scrollbars/vertical_scrollbar.dart';

import '../../../../base_test_widget.dart';

void main() {
  testWidgets('MainScreenBodySongList widget test.', (tester) async {
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
      find.byWidgetPredicate((w) => (w is Column &&
          w.children.length == 2 &&
          w.children.first is UnderlineHeader &&
          (w.children.first as UnderlineHeader).header == '<PLAYLIST NAME HERE>' &&
          w.children.last is Expanded &&
          (w.children.last as Expanded).child is VerticalScrollbar &&
          ((w.children.last as Expanded).child as VerticalScrollbar).children.length == 50)),
      findsOneWidget,
    );

    expect(
      find.byWidgetPredicate(
        (w) => w is Padding && w.padding == const EdgeInsets.only(top: 5, bottom: 0),
      ),
      findsNWidgets(49),
    );
    expect(
      find.byWidgetPredicate(
        (w) => w is Padding && w.padding == const EdgeInsets.only(top: 5, bottom: 5),
      ),
      findsOneWidget,
    );
    expect(
      find.byWidgetPredicate(
        (w) => w is BaseHoverButton && w.padding == const EdgeInsets.symmetric(vertical: 3, horizontal: 5),
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
          (w.children[2] as Expanded).child is Column &&
          w.children[3] is SizedBox &&
          (w.children[3] as SizedBox).width == 10 &&
          w.children[4] is Expanded &&
          (w.children[4] as Expanded).child is Text &&
          w.children[5] is SizedBox &&
          (w.children[5] as SizedBox).width == 10 &&
          w.children.last is Text)),
      findsNWidgets(50),
    );
    expect(
      find.byWidgetPredicate(
          (w) => (w is Icon && w.icon == Icons.music_note && w.size == ImageSizeEnum.small.size + 10 && w.color == DarkModeColorDesignSystem.onBackground)),
      findsNWidgets(50),
    );
    expect(
      find.byWidgetPredicate((w) => (w is Column &&
          w.crossAxisAlignment == CrossAxisAlignment.start &&
          w.children.length == 2 &&
          w.children.first is Text &&
          (w.children.first as Text).maxLines == 1 &&
          (w.children.first as Text).overflow == TextOverflow.ellipsis &&
          (w.children.first as Text).data == 'Song name qwijeeqijqeiorjqo ejwqoie jwqoie jqwoiej' &&
          w.children.last is Text &&
          (w.children.last as Text).maxLines == 1 &&
          (w.children.last as Text).overflow == TextOverflow.ellipsis &&
          (w.children.last as Text).data == 'SOng aritqe qwoune oiwje iwoqje oiqwje qwioej')),
      findsNWidgets(50),
    );
    expect(
      find.byWidgetPredicate(
          (w) => (w is Text && w.maxLines == 1 && w.overflow == TextOverflow.ellipsis && w.data == 'aLijeqwje oqwiejqwiejwqoeijqoiejqwioje iqwje')),
      findsNWidgets(50),
    );
    expect(
      find.byWidgetPredicate((w) => w is Text && w.data == '420:00'),
      findsNWidgets(50),
    );
  });
}
