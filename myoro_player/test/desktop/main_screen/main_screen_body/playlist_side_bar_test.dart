import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/blocs/playlist_side_bar_cubit.dart';
import 'package:myoro_player/desktop/main_screen/main_screen_body/playlist_side_bar.dart';
import 'package:myoro_player/widgets/dividers/basic_divider.dart';
import 'package:myoro_player/widgets/dividers/resize_divider.dart';

import '../../../base_test_widget.dart';

void main() {
  testWidgets('PlaylistSideBar Widget Test', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        testType: TestTypeEnum.widget,
        child: BlocProvider(
          create: (_) => PlaylistSideBarCubit(),
          child: const PlaylistSideBar(),
        ),
      ),
    );

    expect(find.byType(PlaylistSideBar), findsOneWidget);

    /// Title + playlist listing section
    expect(find.text('Playlists'), findsOneWidget);
    expect(find.byType(BasicDivider), findsOneWidget);
    expect(find.byType(SingleChildScrollView), findsOneWidget);

    /// [ResizeDivider] Section
    expect(find.byType(ResizeDivider), findsOneWidget);
  });
}
