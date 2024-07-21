import 'package:flutter/material.dart';
import 'package:myoro_player/core/controllers/base_drawer_controller.dart';
import 'package:provider/provider.dart';

/// When creating a new screen, it must use [BaseScaffold]
final class BaseScaffold extends StatefulWidget {
  final PreferredSizeWidget? appBar;
  final Widget? body;

  const BaseScaffold({super.key, this.appBar, this.body});

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
        builder: (_, __) {
          return Scaffold(
            key: _drawerController.scaffoldKey,
            appBar: widget.appBar,
            body: widget.body,
            drawer: _drawerController.drawer ?? const SizedBox.shrink(),
            endDrawer: _drawerController.endDrawer ?? const SizedBox.shrink(),
            drawerEnableOpenDragGesture: false,
            endDrawerEnableOpenDragGesture: false,
          );
        },
      ),
    );
  }
}
