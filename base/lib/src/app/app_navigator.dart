import 'package:flutter/material.dart';

abstract final class AppNavigator {
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  static NavigatorState get navigator => navigatorKey.currentState!;

  static BuildContext get context => navigator.context;

  static OverlayState get overlay => navigator.overlay!;
}
