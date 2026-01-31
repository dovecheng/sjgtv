import 'package:flutter/material.dart';
import 'package:sjgtv/src/app/theme/app_theme.dart';

/// 网络图片加载占位（与 [networkImageErrorWidget] 配套使用）
Widget networkImagePlaceholder(BuildContext context) {
  final Color color = context.appThemeColors.surfaceVariant;
  return ColoredBox(
    color: color,
    child: const Center(
      child: CircularProgressIndicator(strokeWidth: 3.0),
    ),
  );
}

/// 网络图片加载失败占位（与 [networkImagePlaceholder] 配套使用）
Widget networkImageErrorWidget(BuildContext context) {
  final Color color = context.appThemeColors.surfaceVariant;
  return ColoredBox(
    color: color,
    child: const Center(
      child: Icon(
        Icons.broken_image,
        color: Colors.grey,
        size: 36,
      ),
    ),
  );
}
