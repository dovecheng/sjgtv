import 'package:flutter/material.dart';
import 'package:sjgtv/core/core.dart';
import 'package:sjgtv/src/app/router/app_router.dart';

/// 空状态组件
///
/// 用于显示友好的空状态提示和引导
class EmptyState extends StatelessWidget {
  const EmptyState({
    super.key,
    required this.title,
    required this.message,
    this.icon,
    this.actionLabel,
    this.onAction,
  });

  final String title;
  final String message;
  final IconData? icon;
  final String? actionLabel;
  final VoidCallback? onAction;

  @override
  Widget build(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null)
              Icon(
                icon,
                size: 80,
                color: colorScheme.surfaceContainerHighest,
              )
            else
              Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  color: colorScheme.surfaceContainer,
                  borderRadius: BorderRadius.circular(60),
                ),
                child: Icon(
                  Icons.movie_outlined,
                  size: 60,
                  color: colorScheme.surfaceContainerHighest,
                ),
              ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.w600,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 12),
            Text(
              message,
              style: TextStyle(
                color: Colors.white70,
                fontSize: 16,
              ),
              textAlign: TextAlign.center,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: 32),
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppTheme.accent,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 16,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  actionLabel!,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

/// 预定义的空状态
class EmptyStates {
  /// 无数据空状态
  static const Widget noData = EmptyState(
    title: '暂无数据',
    message: '当前没有找到任何内容，请稍后再试',
    icon: Icons.inbox_outlined,
  );

  /// 无电影数据空状态
  static const Widget noMovies = EmptyState(
    title: '没有找到电影',
    message: '当前分类下没有电影数据，尝试切换其他分类',
    icon: Icons.movie_filter_outlined,
  );

  /// 无标签空状态
  static const Widget noTags = EmptyState(
    title: '暂无标签',
    message: '请先添加标签分类',
    icon: Icons.label_outlined,
  );

  /// 网络错误空状态
  static const Widget networkError = EmptyState(
    title: '网络连接失败',
    message: '请检查您的网络连接后重试',
    icon: Icons.cloud_off_outlined,
  );

  /// 无搜索结果空状态
  static const Widget noSearchResults = EmptyState(
    title: '未找到结果',
    message: '尝试使用其他关键词搜索',
    icon: Icons.search_off_outlined,
  );
}