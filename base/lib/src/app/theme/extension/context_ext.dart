import 'dart:ui';

import 'package:flutter/material.dart';

extension BuildContextThemeExt on BuildContext {
  /// 获取 Flutter 视图
  FlutterView get flutterView => View.of(this);

  /// 应用窗口信息, 要在脚手架之上的 [context] 才能得到设备的 [MediaQueryData.padding]
  MediaQueryData get mediaQuery => MediaQuery.of(this);

  /// 获取应用主题
  ThemeData get theme => Theme.of(this);
}
