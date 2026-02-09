/// 布局断点常量
class LayoutBreakpoints {
  LayoutBreakpoints._();

  /// 手机竖屏断点（约 400dp）
  static const double phonePortrait = 400;

  /// 手机横屏断点（约 700dp）
  static const double phoneLandscape = 700;

  /// 平板竖屏断点（约 900dp）
  static const double tabletPortrait = 900;

  /// 平板横屏断点（约 1200dp）
  static const double tabletLandscape = 1200;

  /// TV 断点（约 1920dp）
  static const double tv = 1920;
}

/// 布局类型
enum LayoutType {
  /// 手机竖屏
  phonePortrait,

  /// 手机横屏
  phoneLandscape,

  /// 平板竖屏
  tabletPortrait,

  /// 平板横屏
  tabletLandscape,

  /// TV（仅横屏）
  tv,
}

/// 响应式网格配置
class ResponsiveGrid {
  ResponsiveGrid._();

  /// 获取网格列数
  static int getGridColumns(double width) {
    if (width >= LayoutBreakpoints.tv) {
      return 6; // TV: 6 列
    } else if (width >= LayoutBreakpoints.tabletLandscape) {
      return 5; // 平板横屏: 5 列
    } else if (width >= LayoutBreakpoints.tabletPortrait) {
      return 4; // 平板竖屏: 4 列
    } else if (width >= LayoutBreakpoints.phoneLandscape) {
      return 3; // 手机横屏: 3 列
    } else {
      return 2; // 手机竖屏: 2 列
    }
  }

  /// 获取卡片宽高比
  static double getCardAspectRatio(bool isPortrait) {
    return isPortrait ? 2 / 3 : 16 / 9;
  }

  /// 获取网格间距
  static double getGridSpacing(double width) {
    if (width >= LayoutBreakpoints.tv) {
      return 16.0; // TV: 16dp
    } else if (width >= LayoutBreakpoints.tabletPortrait) {
      return 12.0; // 平板: 12dp
    } else {
      return 8.0; // 手机: 8dp
    }
  }

  /// 获取内容内边距
  static double getContentPadding(double width) {
    if (width >= LayoutBreakpoints.tv) {
      return 32.0; // TV: 32dp
    } else if (width >= LayoutBreakpoints.tabletPortrait) {
      return 24.0; // 平板: 24dp
    } else {
      return 16.0; // 手机: 16dp
    }
  }

  /// 计算 Hero Banner 高度
  static double getHeroBannerHeight(double width) {
    if (width >= LayoutBreakpoints.tv) {
      return width * 0.5; // TV: 50% 高度
    } else if (width >= LayoutBreakpoints.tabletPortrait) {
      return width * 0.4; // 平板: 40% 高度
    } else {
      return width * 0.3; // 手机: 30% 高度
    }
  }
}