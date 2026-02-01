import 'dart:ui';

import 'package:flutter/material.dart';

import 'package:base/app.dart';

/// 设备类型枚举
enum DeviceType {
  phone, // 手机
  tablet, // 平板
  tv, // 电视
}

extension BuildContextThemeExt on BuildContext {
  FlutterView get flutterView => View.of(this);

  /// 应用窗口信息, 要在脚手架之上的 [context] 才能得到设备的 [MediaQueryData.padding]
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// 判断当前设备类型
  DeviceType get deviceType {
    final double shortestSide = mediaQuery.size.shortestSide;
    // 常规判断标准（可根据实际需求调整）
    // 电视通常有更大屏幕，比如大于 900
    if (shortestSide >= 900) {
      return DeviceType.tv;
    }
    // 平板通常大于等于 600，小于 900
    if (shortestSide >= 600) {
      return DeviceType.tablet;
    }
    // 其余视为手机
    return DeviceType.phone;
  }

  /// 获取应用主题
  ThemeData get theme => Theme.of(this);

  /// 暗黑主题模式
  bool get isDark => theme.brightness.isDark;

  /// 正常主题模式
  bool get isLight => theme.brightness.isLight;
}
