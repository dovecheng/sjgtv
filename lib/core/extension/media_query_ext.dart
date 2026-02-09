import 'dart:io';
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
    // 首先检测是否为桌面平台
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
