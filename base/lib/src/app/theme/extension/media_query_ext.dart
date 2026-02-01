import 'package:flutter/material.dart';

/// 设备类型枚举
enum DeviceType {
  phone, // 手机
  tablet, // 平板
  tv, // 电视
}

extension MediaQueryDataDeviceTypeExt on MediaQueryData {
  /// 判断当前设备类型
  DeviceType get deviceType {
    final double shortestSide = size.shortestSide;
    if (shortestSide >= 900) {
      return DeviceType.tv;
    }
    if (shortestSide >= 600) {
      return DeviceType.tablet;
    }
    return DeviceType.phone;
  }
}
