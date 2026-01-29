import 'package:flutter/material.dart';

extension BrightnessExt on Brightness {
  /// 切换主题亮度
  Brightness toggle() {
    switch (this) {
      case Brightness.light:
        return Brightness.dark;
      case Brightness.dark:
        return Brightness.light;
    }
  }

  /// 是否暗黑模式
  bool get isDark => this == Brightness.dark;

  /// 是否正常模式
  bool get isLight => this == Brightness.light;

  /// 主题亮度转主题模式
  ThemeMode toThemeMode() {
    switch (this) {
      case Brightness.light:
        return ThemeMode.light;
      case Brightness.dark:
        return ThemeMode.dark;
    }
  }
}
