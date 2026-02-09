import 'package:flutter/material.dart';
import 'package:sjgtv/core/extension/media_query_ext.dart';

/// 屏幕方向
enum ScreenOrientation {
  /// 竖屏
  portrait,

  /// 横屏
  landscape,
}

/// BuildContext 扩展方法，提供设备信息
extension DeviceInfoExtension on BuildContext {
  /// 获取设备类型（使用 media_query_ext.dart 中的定义）
  DeviceType get deviceType => MediaQuery.of(this).deviceType;

  /// 获取屏幕方向
  ScreenOrientation get orientation {
    final size = MediaQuery.of(this).size;
    return size.width > size.height
        ? ScreenOrientation.landscape
        : ScreenOrientation.portrait;
  }

  /// 判断是否是 TV 设备
  bool get isTV => deviceType == DeviceType.tv;

  /// 判断是否是平板设备
  bool get isTablet => deviceType == DeviceType.tablet;

  /// 判断是否是手机设备
  bool get isPhone => deviceType == DeviceType.phone;

  /// 判断是否是横屏
  bool get isLandscape => orientation == ScreenOrientation.landscape;

  /// 判断是否是竖屏
  bool get isPortrait => orientation == ScreenOrientation.portrait;

  /// 获取屏幕宽度（dp）
  double get screenWidth => MediaQuery.of(this).size.width;

  /// 获取屏幕高度（dp）
  double get screenHeight => MediaQuery.of(this).size.height;

  /// 获取屏幕较短边
  double get shortestSide => MediaQuery.of(this).size.shortestSide;

  /// 获取屏幕较长边
  double get longestSide => MediaQuery.of(this).size.longestSide;

  /// 计算宽高比
  double get aspectRatio {
    final size = MediaQuery.of(this).size;
    return size.width / size.height;
  }

  /// 判断是否是宽屏（宽高比 > 1.5）
  bool get isWideScreen => aspectRatio > 1.5;
}