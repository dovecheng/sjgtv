import 'package:flutter/material.dart';
import 'package:sjgtv/core/platform/device_type.dart';
import 'package:sjgtv/core/responsive/layout_breakpoints.dart';

/// BuildContext 扩展方法，提供响应式布局功能
extension ResponsiveLayoutExtension on BuildContext {
  /// 获取布局类型
  LayoutType get layoutType {
    final width = screenWidth;

    if (width >= LayoutBreakpoints.tv) {
      return LayoutType.tv;
    } else if (width >= LayoutBreakpoints.tabletLandscape) {
      return LayoutType.tabletLandscape;
    } else if (width >= LayoutBreakpoints.tabletPortrait) {
      return LayoutType.tabletPortrait;
    } else if (width >= LayoutBreakpoints.phoneLandscape) {
      return LayoutType.phoneLandscape;
    } else {
      return LayoutType.phonePortrait;
    }
  }

  /// 获取网格列数
  int get gridColumns => ResponsiveGrid.getGridColumns(screenWidth);

  /// 获取卡片宽高比
  double get cardAspectRatio => ResponsiveGrid.getCardAspectRatio(isPortrait);

  /// 获取网格间距
  double get gridSpacing => ResponsiveGrid.getGridSpacing(screenWidth);

  /// 获取内容内边距
  double get contentPadding => ResponsiveGrid.getContentPadding(screenWidth);

  /// 获取 Hero Banner 高度
  double get heroBannerHeight => ResponsiveGrid.getHeroBannerHeight(screenWidth);

  /// 判断是否应该使用底部导航（TV 使用顶部导航，desktop 使用底部导航）
  bool get useBottomNavigation => !isTV;

  /// 判断是否应该使用顶部导航（TV 使用顶部导航）
  bool get useTopNavigation => isTV;

  /// 判断是否应该自动全屏（仅 TV 自动全屏，desktop 和平板不自动全屏）
  bool get shouldAutoFullScreen => isTV;

  /// 判断是否应该启用焦点系统（仅 TV 启用焦点，desktop 使用鼠标交互）
  bool get shouldEnableFocus => isTV;

  /// 判断是否应该显示状态栏（TV 隐藏状态栏，desktop 和平板显示状态栏）
  bool get shouldShowStatusBar => !isTV;

  /// 判断是否应该显示系统导航栏（TV 隐藏系统导航栏，desktop 和平板显示系统导航栏）
  bool get shouldShowSystemNavigation => !isTV;

  /// 获取字体大小缩放因子
  double get fontScale {
    final width = screenWidth;
    if (width >= LayoutBreakpoints.tv) {
      return 1.2; // TV: 字体放大 20%
    } else if (width >= LayoutBreakpoints.tabletPortrait) {
      return 1.1; // 平板/desktop: 字体放大 10%
    } else {
      return 1.0; // 手机: 正常大小
    }
  }

  /// 获取图标大小缩放因子
  double get iconScale {
    final width = screenWidth;
    if (width >= LayoutBreakpoints.tv) {
      return 1.3; // TV: 图标放大 30%
    } else if (width >= LayoutBreakpoints.tabletPortrait) {
      return 1.15; // 平板/desktop: 图标放大 15%
    } else {
      return 1.0; // 手机: 正常大小
    }
  }

  /// 判断是否应该使用较大的触摸目标（仅 TV 需要大的触摸目标，desktop 使用鼠标，平板使用触摸）
  bool get useLargeTouchTarget => isTV;

  /// 获取触摸目标最小尺寸
  double get touchTargetSize {
    return useLargeTouchTarget ? 56.0 : 48.0;
  }

  /// 判断是否应该使用紧凑布局（手机竖屏）
  bool get isCompactLayout => layoutType == LayoutType.phonePortrait;

  /// 判断是否应该使用宽松布局（TV、平板和 desktop）
  bool get isSpaciousLayout => isTV || isTablet || isDesktop;

  /// 根据布局类型返回不同值
  T whenLayout<T>({
    required T Function() phonePortrait,
    required T Function() phoneLandscape,
    required T Function() tabletPortrait,
    required T Function() tabletLandscape,
    required T Function() tv,
  }) {
    switch (layoutType) {
      case LayoutType.phonePortrait:
        return phonePortrait();
      case LayoutType.phoneLandscape:
        return phoneLandscape();
      case LayoutType.tabletPortrait:
        return tabletPortrait();
      case LayoutType.tabletLandscape:
        return tabletLandscape();
      case LayoutType.tv:
        return tv();
    }
  }
}