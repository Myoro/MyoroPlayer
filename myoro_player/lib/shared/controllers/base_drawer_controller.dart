import 'package:flutter/material.dart';

/// Named BaseDrawerController instead of DrawerController
/// as Flutter's material library has stolen that name...
final class BaseDrawerController extends ChangeNotifier {
  final _scaffoldKey = GlobalKey<ScaffoldState>();

  void openDrawer() {
    _scaffoldKey.currentState?.openEndDrawer();
  }

  void closeDrawer() {
    _scaffoldKey.currentState?.closeDrawer();
  }

  GlobalKey<ScaffoldState> get scaffoldKey => _scaffoldKey;
}
