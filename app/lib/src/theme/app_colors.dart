import 'package:flutter/material.dart';

/// 应用统一颜色常量
///
/// 页面与组件应优先使用此类常量，便于统一风格与后续主题切换。
abstract final class AppColors {
  AppColors._();

  /// 主背景（Scaffold 等）
  static const Color background = Color(0xFF121212);

  /// 卡片/次级背景
  static const Color cardBackground = Color(0xFF1E1E1E);

  /// 卡片表面（如电影卡片内衬）
  static const Color cardSurface = Color(0xFF262626);

  /// 表面变体（Tab 未选、占位、按钮未聚焦等）
  static const Color surfaceVariant = Color(0xFF333333);

  /// 主色（强调、焦点、链接等）
  static const Color primary = Color(0xFF00C8FF);

  /// 主题种子色（Material 主题生成用）
  static const Color seedColor = Color(0xFF0066FF);

  /// 错误/警告（SnackBar 错误等）
  static const Color error = Color(0xFFB00020);

  /// 提示/次要文字
  static const Color hint = Color(0xFFAAAAAA);
}
