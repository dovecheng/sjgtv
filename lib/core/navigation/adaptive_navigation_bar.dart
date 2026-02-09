import 'package:flutter/material.dart';
import 'package:sjgtv/core/responsive/responsive_layout.dart';

/// 自适应导航栏组件
///
/// 根据设备类型自动选择顶部或底部导航
class AdaptiveNavigationBar extends StatelessWidget {
  const AdaptiveNavigationBar({
    super.key,
    required this.currentIndex,
    required this.onDestinationSelected,
    required this.destinations,
  });

  /// 当前选中的索引
  final int currentIndex;

  /// 导航项选中回调
  final ValueChanged<int> onDestinationSelected;

  /// 导航项列表（使用 Flutter 自带的 NavigationDestination）
  final List<NavigationDestination> destinations;

  @override
  Widget build(BuildContext context) {
    // TV 使用顶部导航栏
    if (context.useTopNavigation) {
      return NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onDestinationSelected,
        destinations: destinations,
        backgroundColor: Theme.of(context).colorScheme.surface,
      );
    }

    // 手机和平板使用底部导航栏
    return NavigationBar(
      selectedIndex: currentIndex,
      onDestinationSelected: onDestinationSelected,
      destinations: destinations,
      backgroundColor: Theme.of(context).colorScheme.surface,
    );
  }
}