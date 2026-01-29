import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:base/app.dart';

extension BuildContextThemeExt on BuildContext {
  FlutterView get flutterView => View.of(this);

  /// 应用窗口信息, 要在脚手架之上的 [context] 才能得到设备的 [MediaQueryData.padding]
  MediaQueryData get mediaQueryData => MediaQuery.of(this);

  /// 获取应用主题
  ThemeData get themeData => Theme.of(this);

  /// 暗黑主题模式
  bool get isDark => themeData.brightness.isDark;

  /// 正常主题模式
  bool get isLight => themeData.brightness.isLight;
}
