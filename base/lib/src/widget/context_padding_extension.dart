import 'dart:math';

import 'package:base/base.dart';
import 'package:flutter/material.dart';

extension ContextPaddingExtension on BuildContext {
  /// 配置异形屏底部高度
  // MARK(wy): 2024-08-15 MediaQuery.paddingOf(this).bottom 键盘弹起时会变为0
  double getMediaQueryPaddingBottom({
    double minPaddingBottom = 16.0,

    /// 是否在AndroidSafeArea下
    bool useAndroidSafeArea = true,
  }) {
    minPaddingBottom = max(minPaddingBottom, 0);

    double bottom = MediaQuery.paddingOf(this).bottom;

    /// iOS
    double iOSBottom = bottom > minPaddingBottom ? bottom : minPaddingBottom;

    /// Android 特殊处理
    if ($platform.isAndroidNative) {
      if (bottom == 0) {
        /// 普通屏幕
        return minPaddingBottom;
      } else {
        /// 异形屏幕

        if (useAndroidSafeArea) {
          /// 在AndroidSafeArea下,直接配置为minPaddingBottom
          return minPaddingBottom;
        } else {
          // TODO(wy): 2025-01-15 如果是全面屏手势，则和iOS一样，否则就相加

          /// 不在AndroidSafeArea下,需要加上bottom
          return bottom + minPaddingBottom;
        }
      }
    }

    return iOSBottom;
  }

  /// 配置异形屏底部高度
  // MARK(wy): 2024-08-15 MediaQuery.viewPaddingOf(context).bottom 键盘弹起时保持不变
  double getMediaQueryViewPaddingBottom({
    double minViewPaddingBottom = 16.0,

    /// 是否在AndroidSafeArea下
    bool useAndroidSafeArea = true,
  }) {
    minViewPaddingBottom = max(minViewPaddingBottom, 0);

    double bottom = MediaQuery.viewPaddingOf(this).bottom;

    /// Android 特殊处理
    if ($platform.isAndroidNative) {
      if (bottom == 0) {
        /// 普通屏幕
        return minViewPaddingBottom;
      } else {
        /// 异形屏幕

        if (useAndroidSafeArea) {
          /// 在AndroidSafeArea下,直接配置为 minViewPaddingBottom
          return minViewPaddingBottom;
        } else {
          /// 不在AndroidSafeArea下,需要加上bottom
          return bottom + minViewPaddingBottom;
        }
      }
    }

    return bottom > minViewPaddingBottom ? bottom : minViewPaddingBottom;
  }
}
