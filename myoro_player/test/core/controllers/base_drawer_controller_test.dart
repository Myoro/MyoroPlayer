import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/core/controllers/base_drawer_controller.dart';
import 'package:myoro_player/core/widgets/drawers/base_drawer.dart';

import '../../base_test_widget.dart';

void main() {
  testWidgets('BaseControllerDrawer Test', (tester) async {
    late final BaseDrawerController drawerController;
    final baseDrawerFinder = find.byType(BaseDrawer);
    const drawer = BaseDrawer(child: SizedBox.shrink());

    await tester.pumpWidget(
      BaseTestWidget(
        child: Builder(
          builder: (context) {
            drawerController = context.read<BaseDrawerController>();

            return const SizedBox.shrink();
          },
        ),
      ),
    );

    drawerController.openDrawer(drawer: drawer);
    await tester.pump();

    expect(baseDrawerFinder, findsOneWidget);

    drawerController.closeDrawer();
    await tester.pump();

    expect(baseDrawerFinder, findsNothing);

    drawerController.openEndDrawer(drawer: drawer);
    await tester.pump();

    expect(baseDrawerFinder, findsOneWidget);

    drawerController.closeEndDrawer();
    await tester.pump();

    expect(baseDrawerFinder, findsNothing);
  });
}
