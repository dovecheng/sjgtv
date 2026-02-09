import 'dart:io' show Platform;
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

/// 设备类型枚举
enum DeviceType {
  phone, // 手机
  tablet, // 平板
  tv, // 电视
  desktop, // 桌面（Windows、macOS、Linux）
}

extension MediaQueryDataDeviceTypeExt on MediaQueryData {
  /// 判断当前设备类型
  DeviceType get deviceType {
    // Web 平台：根据屏幕尺寸分类（与移动设备相同）
    if (kIsWeb) {
      return switch (size.shortestSide) {
        >= 900 => DeviceType.tv,
        >= 600 => DeviceType.tablet,
        _ => DeviceType.phone,
      };
    }

    // 桌面平台（Windows、macOS、Linux）
    if (Platform.isWindows || Platform.isMacOS || Platform.isLinux) {
      return DeviceType.desktop;
    }

    // 移动设备按屏幕尺寸分类
    return switch (size.shortestSide) {
      >= 900 => DeviceType.tv,
      >= 600 => DeviceType.tablet,
      _ => DeviceType.phone,
    };
  }
}
