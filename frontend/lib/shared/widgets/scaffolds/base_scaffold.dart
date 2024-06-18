import 'package:flutter/material.dart';
import 'package:frontend/shared/controllers/base_drawer_controller.dart';
import 'package:frontend/shared/widgets/drawers/base_drawer.dart';
import 'package:provider/provider.dart';

/// Use this whenever creating a new screen (i.e. MainScreen, any widget with a [Scaffold])
final class BaseScaffold extends StatefulWidget {
  final PreferredSizeWidget appBar;
  final Widget body;

  const BaseScaffold({
    super.key,
    required this.appBar,
    required this.body,
  });

  @override
  State<BaseScaffold> createState() => _BaseScaffoldState();
}

class _BaseScaffoldState extends State<BaseScaffold> {
  final _drawerController = BaseDrawerController();

  @override
  void dispose() {
    _drawerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return InheritedProvider.value(
      value: _drawerController,
      child: ListenableBuilder(
        listenable: _drawerController,
        builder: (context, _) {
          return Scaffold(
            key: _drawerController.scaffoldKey,
            appBar: widget.appBar,
            body: widget.body,
            endDrawer: BaseDrawer(
              title: _drawerController.drawerTitle,
              child: _drawerController.drawerContent ?? const SizedBox.shrink(),
            ),
          );
        },
      ),
    );
  }
}
