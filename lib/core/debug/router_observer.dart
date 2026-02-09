import 'package:flutter/material.dart';
import 'package:sjgtv/core/log/log.dart';

/// 路由日志监听器
///
/// 监听并记录所有路由变化事件
class RouterObserver extends NavigatorObserver {
  String? _currentRoute;
  String? _previousRoute;

  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logRouteChange('push', route, previousRoute);
  }

  @override
  void didPop(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logRouteChange('pop', route, previousRoute);
  }

  @override
  void didRemove(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _logRouteChange('remove', route, previousRoute);
  }

  @override
  void didReplace({Route<dynamic>? newRoute, Route<dynamic>? oldRoute}) {
    _logRouteChange('replace', newRoute, oldRoute);
  }

  @override
  void didStartUserGesture(Route<dynamic> route, Route<dynamic>? previousRoute) {
    log.d(() => '用户手势开始: ${route.settings.name}');
  }

  @override
  void didStopUserGesture() {
    log.d(() => '用户手势停止');
  }

  void _logRouteChange(
    String action,
    Route<dynamic>? route,
    Route<dynamic>? previousRoute,
  ) {
    _previousRoute = _currentRoute;
    _currentRoute = route?.settings.name ?? 'unknown';
    final previousName = previousRoute?.settings.name ?? 'unknown';
    final routeName = route?.settings.name ?? 'unknown';

    log.i(() => '路由$action: $previousName -> $routeName');
  }

  /// 获取当前路由名称
  String? get currentRoute => _currentRoute;

  /// 获取上一个路由名称
  String? get previousRoute => _previousRoute;
}