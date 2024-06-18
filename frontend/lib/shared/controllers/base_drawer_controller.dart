import 'package:flutter/material.dart';

/// Named BaseDrawerController and not DrawerController as the Material Flutter has already used that name
final class BaseDrawerController extends ChangeNotifier {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  String? _drawerTitle;
  Widget? _drawerContent;

  void openDrawer({
    String? drawerTitle,
    required Widget drawerContent,
  }) {
    _drawerTitle = drawerTitle;
    _drawerContent = drawerContent;
    notifyListeners();
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void closeDrawer() {
    _scaffoldKey.currentState?.closeEndDrawer();
    _drawerTitle = null;
    _drawerContent = null;
    notifyListeners();
  }

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
  String? get drawerTitle => _drawerTitle;
  Widget? get drawerContent => _drawerContent;
}
