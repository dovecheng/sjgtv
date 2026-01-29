import 'dart:ui';

import 'package:base/app.dart';
import 'package:flutter/material.dart';

extension ThemeModeToBrightnessExt on ThemeMode {
  /// 是否暗黑模式
  bool get isDark => toBrightness().isDark;

  /// 是否正常模式
  bool get isLight => toBrightness().isLight;

  /// 主题模式转主题亮度
  Brightness toBrightness() => switch (this) {
    ThemeMode.system => PlatformDispatcher.instance.platformBrightness,
    ThemeMode.light => Brightness.light,
    ThemeMode.dark => Brightness.dark,
  };
}

extension ThemeModeToggleExt on ThemeMode {
  /// 主题模式转主题亮度
  ThemeMode toggle() => toBrightness().toggle().toThemeMode();
}
