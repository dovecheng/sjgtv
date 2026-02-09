import '../../core/env.dart';
import 'package:flutter/foundation.dart';

/// see also: [defaultTargetPlatform]
TargetPlatform get $platform => defaultTargetPlatform;

/// 当前系统类型枚举 [defaultTargetPlatform] 扩展方法
extension TargetPlatformExt on TargetPlatform {
  /// 当前环境是否为原生Android
  bool get isAndroidNative => kIsNative && this == TargetPlatform.android;

  /// 当前环境是否为原生IOS
  bool get isIOSNative => kIsNative && this == TargetPlatform.iOS;

  /// 当前环境是否为原生并且是IOS或Android
  bool get isMobileNative =>
      kIsNative &&
      (this == TargetPlatform.android || this == TargetPlatform.iOS);

  /// 当前环境是否为原生Linux
  bool get isLinuxNative => kIsNative && this == TargetPlatform.linux;

  /// 当前环境是否为原生MacOS
  bool get isMacOSNative => kIsNative && this == TargetPlatform.macOS;

  /// 当前环境是否为原生Windows
  bool get isWindowsNative => kIsNative && this == TargetPlatform.windows;

  /// 当前环境是否为原生并且是MacOS, Windows或Linux
  bool get isDesktopNative =>
      kIsNative &&
      (this == TargetPlatform.linux ||
          this == TargetPlatform.macOS ||
          this == TargetPlatform.windows);

  /// 检查当前目标平台是否支持
  bool isAny({
    bool web = false,
    bool android = false,
    bool fuchsia = false,
    bool iOS = false,
    bool linux = false,
    bool macOS = false,
    bool windows = false,
  }) {
    if (kIsWeb) {
      return web;
    } else {
      switch (this) {
        case TargetPlatform.android:
          return android;
        case TargetPlatform.fuchsia:
          return fuchsia;
        case TargetPlatform.iOS:
          return iOS;
        case TargetPlatform.linux:
          return linux;
        case TargetPlatform.macOS:
          return macOS;
        case TargetPlatform.windows:
          return windows;
      }
    }
  }
}
