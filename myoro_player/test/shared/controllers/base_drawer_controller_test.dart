import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:myoro_player/shared/controllers/base_drawer_controller.dart';
import 'package:myoro_player/shared/widgets/drawers/base_drawer.dart';

import '../../base_test_widget.dart';

void main() {
  testWidgets('BaseControllerDrawer Test', (tester) async {
    late final BaseDrawerController drawerController;
    final Finder baseDrawerFinder = find.byType(BaseDrawer);

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

    drawerController.openDrawer(drawer: const BaseDrawer(child: SizedBox.shrink()));
    await tester.pump();

    expect(baseDrawerFinder, findsOneWidget);

    drawerController.closeDrawer();
    await tester.pump();

    expect(baseDrawerFinder, findsNothing);
  });
}
