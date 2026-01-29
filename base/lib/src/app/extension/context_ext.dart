import 'package:flutter/material.dart';

extension BuildContextNavigatorExt on BuildContext {
  /// 导航器, 要获取顶级导航器, 需要使用 [AppNavigator.navigator]
  NavigatorState get navigator => Navigator.of(this);
}
