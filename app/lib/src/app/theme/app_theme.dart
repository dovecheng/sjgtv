import 'package:base/app.dart';
import 'package:flutter/material.dart';
import 'package:sjgtv/src/app/theme/app_colors.dart';

/// 应用主题色板（由 [AppColors] 注入，UI 通过 [ThemeExtension] 使用）
@immutable
class AppThemeColors extends ThemeExtension<AppThemeColors> {
  const AppThemeColors({
    required this.background,
    required this.cardBackground,
    required this.cardSurface,
    required this.surfaceVariant,
    required this.primary,
    required this.error,
    required this.hint,
    required this.seedColor,
  });

  final Color background;
  final Color cardBackground;
  final Color cardSurface;
  final Color surfaceVariant;
  final Color primary;
  final Color error;
  final Color hint;
  final Color seedColor;

  /// 从 [AppColors] 构建默认深色主题色板
  factory AppThemeColors.fromAppColors() => AppThemeColors(
        background: AppColors.background,
        cardBackground: AppColors.cardBackground,
        cardSurface: AppColors.cardSurface,
        surfaceVariant: AppColors.surfaceVariant,
        primary: AppColors.primary,
        error: AppColors.error,
        hint: AppColors.hint,
        seedColor: AppColors.seedColor,
      );

  @override
  AppThemeColors copyWith({
    Color? background,
    Color? cardBackground,
    Color? cardSurface,
    Color? surfaceVariant,
    Color? primary,
    Color? error,
    Color? hint,
    Color? seedColor,
  }) =>
      AppThemeColors(
        background: background ?? this.background,
        cardBackground: cardBackground ?? this.cardBackground,
        cardSurface: cardSurface ?? this.cardSurface,
        surfaceVariant: surfaceVariant ?? this.surfaceVariant,
        primary: primary ?? this.primary,
        error: error ?? this.error,
        hint: hint ?? this.hint,
        seedColor: seedColor ?? this.seedColor,
      );

  @override
  AppThemeColors lerp(ThemeExtension<AppThemeColors>? other, double t) {
    if (other is! AppThemeColors) return this;
    return AppThemeColors(
      background: Color.lerp(background, other.background, t)!,
      cardBackground: Color.lerp(cardBackground, other.cardBackground, t)!,
      cardSurface: Color.lerp(cardSurface, other.cardSurface, t)!,
      surfaceVariant: Color.lerp(surfaceVariant, other.surfaceVariant, t)!,
      primary: Color.lerp(primary, other.primary, t)!,
      error: Color.lerp(error, other.error, t)!,
      hint: Color.lerp(hint, other.hint, t)!,
      seedColor: Color.lerp(seedColor, other.seedColor, t)!,
    );
  }
}

/// [BuildContext] 扩展：获取应用主题色板（基于 base 的 [theme]）
extension AppThemeColorsExtension on BuildContext {
  AppThemeColors get appThemeColors =>
      theme.extension<AppThemeColors>()!;
}
