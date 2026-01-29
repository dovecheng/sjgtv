import 'package:base/app.dart';
import 'package:base/provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/// 状态栏模式
enum SystemUiOverlayMode {
  /// 与主题的亮度相反
  theme,

  /// 状态栏图标为深色
  dark,

  /// 状态栏图标为浅色
  light;

  static const SystemUiOverlayStyle _systemUiOverlayStyle =
      SystemUiOverlayStyle(
        systemNavigationBarIconBrightness: Brightness.light,
        systemNavigationBarColor: Colors.black,
        systemNavigationBarDividerColor: null,
        statusBarColor: Colors.transparent,
      );

  /// System overlays should be drawn with a light color. Intended for
  /// applications with a dark background.
  static final SystemUiOverlayStyle lightSystemUiOverlayStyle =
      _systemUiOverlayStyle.copyWith(
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.dark,
      );

  /// System overlays should be drawn with a dark color. Intended for
  /// applications with a light background.
  static final SystemUiOverlayStyle darkSystemUiOverlayStyle =
      _systemUiOverlayStyle.copyWith(
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.light,
      );

  /// 获取状态栏样式
  SystemUiOverlayStyle toStyle() => switch (this) {
    SystemUiOverlayMode.theme =>
      ($ref.read(appThemeModeProvider).value ?? ThemeMode.system)
              .toBrightness()
              .isDark
          ? lightSystemUiOverlayStyle
          : darkSystemUiOverlayStyle,
    SystemUiOverlayMode.dark => darkSystemUiOverlayStyle,
    SystemUiOverlayMode.light => lightSystemUiOverlayStyle,
  };
}
