import 'package:flutter/material.dart';

abstract final class AppNavigator {
  /// 根 Navigator 的 key，用于获取 NavigatorState 和上下文。
  static final GlobalKey<NavigatorState> navigatorKey = GlobalKey();

  /// 根 Navigator 的 state，即顶级路由状态。
  static NavigatorState get navigator => navigatorKey.currentState!;

  /// 根 Navigator 的 context，即顶级路由上下文。
  static BuildContext get context => navigator.context;

  /// 顶级路由上下文（与 [context] 相同，语义更明确）。
  static BuildContext get topRouteContext => navigator.context;

  /// 根 Navigator 的 overlay，即顶级路由 overlay。
  static OverlayState get overlay => navigator.overlay!;
}
