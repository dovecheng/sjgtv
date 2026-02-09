import 'package:flutter/material.dart';
import 'package:base/base.dart';

final Log _log = Log('TVMode');

/// TV 模式配置
class TVModeConfig {
  TVModeConfig._();

  /// 是否启用 TV 模式
  static bool _isEnabled = false;

  /// 设备类型
  static DeviceType? _deviceType;

  /// 初始化 TV 模式
  static void init(BuildContext context) {
    _deviceType = MediaQuery.of(context).deviceType;
    _isEnabled = _isTVDevice();
    _log.d(() => 'TV 模式初始化: enabled=$_isEnabled, deviceType=$_deviceType');
  }

  /// 检测是否为 TV 设备
  static bool _isTVDevice() {
    // 检测平台
    if ($platform.isAndroidNative || $platform.isIOSNative) {
      // 移动设备默认启用 TV 模式（支持连接 TV）
      return true;
    }

    // 检测设备类型
    if (_deviceType == DeviceType.tv) {
      return true;
    }

    // 检测屏幕尺寸（大屏幕可能是 TV）
    if (_deviceType != null) {
      final Size size = _getScreenSize();
      if (size.width >= 1920 && size.height >= 1080) {
        return true;
      }
    }

    return false;
  }

  /// 获取屏幕尺寸
  static Size _getScreenSize() {
    // 这里需要实际获取屏幕尺寸
    // 暂时返回默认值
    return const Size(1920, 1080);
  }

  /// 是否启用 TV 模式
  static bool get isEnabled => _isEnabled;

  /// 是否为 TV 设备
  static bool get isTV => _deviceType == DeviceType.tv;

  /// 是否支持 TV 优化
  static bool get supportsTVOptimization => _isEnabled;

  /// 获取设备类型
  static DeviceType? get deviceType => _deviceType;

  /// 手动启用 TV 模式
  static void enable() {
    _isEnabled = true;
    _log.d(() => 'TV 模式已手动启用');
  }

  /// 手动禁用 TV 模式
  static void disable() {
    _isEnabled = false;
    _log.d(() => 'TV 模式已手动禁用');
  }

  /// TV 模式下是否显示焦点指示器
  static bool get showFocusIndicator => _isEnabled;

  /// TV 模式下是否启用键盘导航
  static bool get enableKeyboardNavigation => _isEnabled;

  /// TV 模式下是否启用快捷键
  static bool get enableShortcuts => _isEnabled;

  /// TV 模式下的焦点边框宽度
  static double get focusBorderWidth => _isEnabled ? 3.0 : 0.0;

  /// TV 模式下的焦点缩放因子
  static double get focusScaleFactor => _isEnabled ? 1.08 : 1.0;

  /// TV 模式下的动画时长
  static Duration get animationDuration => _isEnabled
      ? const Duration(milliseconds: 300)
      : const Duration(milliseconds: 150);

  /// TV 模式下的默认网格列数
  static int get defaultGridColumns => _isEnabled ? 5 : 3;

  /// TV 模式下的最小触摸目标尺寸
  static double get minTouchTarget => _isEnabled ? 48.0 : 44.0;

  /// TV 模式下的卡片间距
  static double get cardSpacing => _isEnabled ? 16.0 : 12.0;

  /// TV 模式下的页面边距
  static double get pagePadding => _isEnabled ? 24.0 : 16.0;

  /// TV 模式下是否启用防抖
  static bool get enableDebounce => _isEnabled;

  /// TV 模式下的防抖时长
  static Duration get debounceDuration => const Duration(milliseconds: 100);

  /// TV 模式下是否启用焦点记忆
  static bool get enableFocusMemory => _isEnabled;

  /// TV 模式下是否启用自动滚动到焦点
  static bool get enableAutoScrollToFocus => _isEnabled;

  /// TV 模式下是否启用边界焦点处理
  static bool get enableBoundaryFocusHandling => _isEnabled;

  /// TV 模式下是否启用循环焦点
  static bool get enableCircularFocus => _isEnabled;

  /// 获取 TV 模式下的推荐焦点动画曲线
  static Curve get focusAnimationCurve => Curves.easeOutCubic;

  /// 获取 TV 模式下的推荐页面过渡动画
  static Curve get pageTransitionCurve => Curves.easeInOutCubic;

  /// TV 模式下的推荐页面过渡时长
  static Duration get pageTransitionDuration => const Duration(milliseconds: 300);

  /// 是否支持语音输入
  static bool get supportsVoiceInput =>
      $platform.isAndroidNative || $platform.isIOSNative;

  /// 是否支持手势导航
  static bool get supportsGestures => !_isEnabled;

  /// 是否为触摸设备
  static bool get isTouchDevice => !_isEnabled;

  /// 是否为 TV 设备
  static bool isTVDevice(BuildContext context) {
    return _deviceType == DeviceType.tv || _isEnabled;
  }

  /// 是否为移动设备
  static bool isMobileDevice(BuildContext context) {
    return _deviceType == DeviceType.phone || _deviceType == DeviceType.tablet || !_isEnabled;
  }

  /// 获取 TV 模式下的建议文字大小
  static double get suggestedTextScale => _isEnabled ? 1.1 : 1.0;

  /// 获取 TV 模式下的建议图标大小
  static double get suggestedIconSize => _isEnabled ? 28.0 : 24.0;

  /// TV 模式下的建议按钮高度
  static double get suggestedButtonHeight => _isEnabled ? 56.0 : 48.0;

  /// TV 模式下的建议输入框高度
  static double get suggestedInputHeight => _isEnabled ? 56.0 : 48.0;

  /// TV 模式下的建议卡片圆角
  static double get suggestedCardRadius => _isEnabled ? 16.0 : 12.0;

  /// TV 模式下的建议弹窗圆角
  static double get suggestedDialogRadius => _isEnabled ? 20.0 : 16.0;

  /// TV 模式下的建议列表项高度
  static double get suggestedListItemHeight => _isEnabled ? 72.0 : 56.0;

  /// 是否应该显示 TV 专用 UI 元素
  static bool shouldShowTVUI() => _isEnabled;

  /// 是否应该隐藏触摸相关 UI 元素
  static bool shouldHideTouchUI() => _isEnabled;

  /// 是否应该启用键盘快捷键
  static bool shouldEnableKeyboardShortcuts() => _isEnabled;

  /// 是否应该启用焦点陷阱
  static bool shouldEnableFocusTrap() => _isEnabled;

  /// 是否应该启用焦点组
  static bool shouldEnableFocusGroup() => _isEnabled;

  /// 获取 TV 模式下的建议焦点策略
  static FocusTraversalPolicy get suggestedFocusPolicy =>
      _isEnabled ? OrderedTraversalPolicy() : ReadingOrderTraversalPolicy();
}

/// TV 模式感知的构建器
///
/// 根据 TV 模式自动调整 UI
class TVModeBuilder extends StatelessWidget {
  const TVModeBuilder({
    super.key,
    required this.builder,
    this.fallbackBuilder,
  });

  final Widget Function(BuildContext context, bool isTVMode) builder;
  final Widget Function(BuildContext context)? fallbackBuilder;

  @override
  Widget build(BuildContext context) {
    if (TVModeConfig.isEnabled) {
      return builder(context, true);
    }

    if (fallbackBuilder != null) {
      return fallbackBuilder!(context);
    }

    return builder(context, false);
  }
}

/// TV 模式感知的焦点装饰
///
/// 根据 TV 模式自动调整焦点效果
class TVModeFocusDecoration {
  const TVModeFocusDecoration._();

  /// 获取推荐的焦点边框
  static Border getRecommendedBorder() {
    if (TVModeConfig.isEnabled) {
      return Border.all(
        color: AppTheme.focus,
        width: TVModeConfig.focusBorderWidth,
      );
    }
    return Border.all(color: Colors.transparent, width: 0);
  }

  /// 获取推荐的焦点阴影
  static List<BoxShadow> getRecommendedShadow() {
    if (TVModeConfig.isEnabled) {
      return [
        BoxShadow(
          color: AppTheme.focus.withValues(alpha: 0.4),
          blurRadius: 12.0,
          spreadRadius: 2.0,
        ),
      ];
    }
    return [];
  }

  /// 获取推荐的焦点缩放
  static double getRecommendedScale() {
    return TVModeConfig.focusScaleFactor;
  }

  /// 获取推荐的焦点动画时长
  static Duration getRecommendedAnimationDuration() {
    return TVModeConfig.animationDuration;
  }

  /// 获取推荐的焦点动画曲线
  static Curve getRecommendedAnimationCurve() {
    return TVModeConfig.focusAnimationCurve;
  }
}

/// TV 模式感知的布局配置
class TVModeLayout {
  const TVModeLayout._();

  /// 获取推荐的网格列数
  static int getRecommendedGridColumns({double? screenWidth}) {
    if (screenWidth != null) {
      if (screenWidth >= 1920) {
        return 6;
      } else if (screenWidth >= 1280) {
        return 5;
      } else if (screenWidth >= 768) {
        return 4;
      }
    }
    return TVModeConfig.defaultGridColumns;
  }

  /// 获取推荐的卡片间距
  static double getRecommendedCardSpacing() {
    return TVModeConfig.cardSpacing;
  }

  /// 获取推荐的页面边距
  static double getRecommendedPagePadding() {
    return TVModeConfig.pagePadding;
  }

  /// 获取推荐的卡片宽高比
  static double getRecommendedCardAspectRatio() {
    return 2.0 / 3.0;
  }

  /// 获取推荐的卡片高度
  static double getRecommendedCardHeight({double? cardWidth}) {
    final double width = cardWidth ?? 200.0;
    return width / getRecommendedCardAspectRatio();
  }
}

/// TV 模式感知的输入配置
class TVModeInput {
  const TVModeInput._();

  /// 是否应该防抖
  static bool shouldDebounce() {
    return TVModeConfig.enableDebounce;
  }

  /// 获取推荐的防抖时长
  static Duration getRecommendedDebounceDuration() {
    return TVModeConfig.debounceDuration;
  }

  /// 是否应该启用焦点记忆
  static bool shouldEnableFocusMemory() {
    return TVModeConfig.enableFocusMemory;
  }

  /// 是否应该启用自动滚动到焦点
  static bool shouldEnableAutoScrollToFocus() {
    return TVModeConfig.enableAutoScrollToFocus;
  }

  /// 是否应该启用边界焦点处理
  static bool shouldEnableBoundaryFocusHandling() {
    return TVModeConfig.enableBoundaryFocusHandling;
  }

  /// 是否应该启用循环焦点
  static bool shouldEnableCircularFocus() {
    return TVModeConfig.enableCircularFocus;
  }
}