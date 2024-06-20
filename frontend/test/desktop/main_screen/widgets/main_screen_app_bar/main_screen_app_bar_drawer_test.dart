import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:frontend/desktop/main_screen/widgets/main_screen_app_bar/main_screen_app_bar_drawer.dart';
import 'package:frontend/shared/controllers/base_drawer_controller.dart';
import 'package:provider/provider.dart';

import '../../../../base_test_widget.dart';

// TODO: Redo this text to display the drawer with the static method show
void main() {
  testWidgets('MainScreenAppBarDrawer Widget Test', (tester) async {
    await tester.pumpWidget(
      BaseTestWidget(
        child: InheritedProvider(
          create: (context) => BaseDrawerController(),
          child: Builder(
            builder: (context) {
              return GestureDetector(
                onTap: () => MainScreenAppBarDrawer.show(context),
              );
            },
          ),
        ),
      ),
    );

    await tester.tap(find.byType(GestureDetector));
  });
}
