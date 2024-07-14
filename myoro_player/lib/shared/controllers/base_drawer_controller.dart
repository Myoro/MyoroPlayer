import 'package:flutter/material.dart';
import 'package:myoro_player/shared/widgets/drawers/base_drawer.dart';

/// Named BaseDrawerController instead of DrawerController
/// as Flutter's material library has stolen that name...
final class BaseDrawerController extends ChangeNotifier {
  final _scaffoldKey = GlobalKey<ScaffoldState>();
  BaseDrawer? _drawer;

  void openDrawer({required BaseDrawer drawer}) {
    _drawer = drawer;
    notifyListeners();
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void closeDrawer() {
    _drawer = null;
    _scaffoldKey.currentState?.closeDrawer();
    notifyListeners();
  }

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  BaseDrawer? get drawer => _drawer;
}
