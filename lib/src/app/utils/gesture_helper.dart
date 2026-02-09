import 'package:flutter/material.dart';
import 'package:sjgtv/core/core.dart';
import 'package:sjgtv/src/app/utils/tv_mode.dart';

/// 手势方向枚举
enum SwipeDirection {
  left,
  right,
  up,
  down,
}

/// 手势辅助工具类
///
/// 提供触摸设备的手势支持功能：
/// - 点击检测
/// - 长按检测
/// - 滑动检测
/// - 触摸反馈
class GestureHelper {
  GestureHelper._();

  /// 是否为触摸设备
  static bool isTouchDevice(BuildContext context) {
    return TVModeConfig.isTouchDevice;
  }

  /// 是否应该显示触摸反馈
  static bool shouldShowTouchFeedback(BuildContext context) {
    return isTouchDevice(context);
  }

  /// 获取推荐的点击波纹颜色
  static Color getRecommendedRippleColor(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;
    return colorScheme.primary.withValues(alpha: 0.2);
  }

  /// 获取推荐的点击高亮颜色
  static Color getRecommendedHighlightColor(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;
    return colorScheme.primary.withValues(alpha: 0.1);
  }

  /// 创建带手势的包装器
  ///
  /// 为 Widget 添加触摸手势支持
  static Widget withGesture({
    required Widget child,
    required VoidCallback? onTap,
    VoidCallback? onLongPress,
    ValueChanged<bool>? onHighlightChanged,
    ValueChanged<bool>? onTapDown,
    ValueChanged<bool>? onTapUp,
    BorderRadius? borderRadius,
    Color? splashColor,
    Color? highlightColor,
    bool enableFeedback = true,
  }) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        onHighlightChanged: onHighlightChanged,
        onTapDown: onTapDown != null ? (_) => onTapDown(true) : null,
        onTapUp: onTapUp != null ? (_) => onTapUp(false) : null,
        borderRadius: borderRadius,
        splashColor: splashColor,
        highlightColor: highlightColor,
        enableFeedback: enableFeedback,
        child: child,
      ),
    );
  }

  /// 创建可点击的容器
  ///
  /// 带触摸反馈的容器
  static Widget clickableContainer({
    required Widget child,
    required VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onDoubleTap,
    BoxDecoration? decoration,
    EdgeInsetsGeometry? padding,
    EdgeInsetsGeometry? margin,
    double? width,
    double? height,
    AlignmentGeometry? alignment,
    Clip? clipBehavior,
    BorderRadius? borderRadius,
    Color? splashColor,
    Color? highlightColor,
    bool enableFeedback = true,
  }) {
    return Container(
      width: width,
      height: height,
      margin: margin,
      padding: padding,
      alignment: alignment,
      decoration: decoration,
      clipBehavior: clipBehavior ?? Clip.none,
      child: withGesture(
        child: child,
        onTap: onTap,
        onLongPress: onLongPress,
        onHighlightChanged: (highlighted) {
          // 可以在这里添加高亮效果
        },
        borderRadius: borderRadius,
        splashColor: splashColor,
        highlightColor: highlightColor,
        enableFeedback: enableFeedback,
      ),
    );
  }

  /// 创建可点击的卡片
  ///
  /// 带触摸反馈的卡片
  static Widget clickableCard({
    required Widget child,
    required VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onDoubleTap,
    Color? color,
    double? elevation,
    ShapeBorder? shape,
    EdgeInsetsGeometry? margin,
    Clip? clipBehavior,
    Color? splashColor,
    Color? highlightColor,
    bool enableFeedback = true,
  }) {
    return Card(
      color: color,
      elevation: elevation,
      shape: shape,
      margin: margin,
      clipBehavior: clipBehavior,
      child: withGesture(
        child: child,
        onTap: onTap,
        onLongPress: onLongPress,
        splashColor: splashColor,
        highlightColor: highlightColor,
        enableFeedback: enableFeedback,
      ),
    );
  }

  /// 创建可滑动的容器
  ///
  /// 检测滑动手势
  static Widget swipeable({
    required Widget child,
    required ValueChanged<SwipeDirection> onSwipe,
    double swipeThreshold = 50.0,
    Duration swipeTimeout = const Duration(milliseconds: 500),
  }) {
    double? startX;
    double? startY;
    DateTime? startTime;

    return GestureDetector(
      onPanStart: (details) {
        startX = details.globalPosition.dx;
        startY = details.globalPosition.dy;
        startTime = DateTime.now();
      },
      onPanEnd: (details) {
        if (startX == null || startY == null || startTime == null) return;

        final DateTime now = DateTime.now();
        if (now.difference(startTime!) > swipeTimeout) return;

        final double dx = details.globalPosition.dx - startX!;
        final double dy = details.globalPosition.dy - startY!;

        if (dx.abs() > dy.abs()) {
          // 水平滑动
          if (dx.abs() > swipeThreshold) {
            onSwipe(dx > 0 ? SwipeDirection.right : SwipeDirection.left);
          }
        } else {
          // 垂直滑动
          if (dy.abs() > swipeThreshold) {
            onSwipe(dy > 0 ? SwipeDirection.down : SwipeDirection.up);
          }
        }

        startX = null;
        startY = null;
        startTime = null;
      },
      child: child,
    );
  }

  /// 创建可长按的容器
  ///
  /// 检测长按手势
  static Widget longPressable({
    required Widget child,
    required VoidCallback onLongPress,
    Duration longPressDuration = const Duration(milliseconds: 500),
    VoidCallback? onCancel,
    Widget Function(BuildContext)? feedbackBuilder,
  }) {
    return GestureDetector(
      onLongPress: onLongPress,
      onLongPressStart: (_) {
        // 长按开始，可以显示反馈
      },
      onLongPressEnd: (_) {
        // 长按结束
      },
      onLongPressCancel: onCancel,
      child: child,
    );
  }

  /// 创建可双击的容器
  ///
  /// 检测双击手势
  static Widget doubleTappable({
    required Widget child,
    required VoidCallback onDoubleTap,
    VoidCallback? onSingleTap,
  }) {
    return GestureDetector(
      onTap: onSingleTap,
      onDoubleTap: onDoubleTap,
      child: child,
    );
  }

  /// 获取触摸感知参数
  static TouchAwareParams getTouchAwareParams(BuildContext context) {
    final bool isTouch = isTouchDevice(context);

    return TouchAwareParams(
      isTouch: isTouch,
      enableRipple: isTouch,
      enableFeedback: isTouch,
      splashColor: getRecommendedRippleColor(context),
      highlightColor: getRecommendedHighlightColor(context),
    );
  }

  /// 检测设备类型
  static Future<DeviceType> detectDeviceType() async {
    // 这里可以添加设备类型检测逻辑
    // 暂时返回 TV 作为默认值
    return DeviceType.tv;
  }

  /// 是否应该禁用焦点（触摸设备上）
  static bool shouldDisableFocus(BuildContext context) {
    return isTouchDevice(context);
  }

  /// 是否应该显示滚动条（触摸设备上）
  static bool shouldShowScrollbar(BuildContext context) {
    return isTouchDevice(context);
  }

  /// 获取推荐的触摸目标大小
  static double getRecommendedTouchTargetSize(BuildContext context) {
    if (isTouchDevice(context)) {
      return 48.0;
    }
    return 0.0; // TV 设备不需要考虑触摸目标大小
  }

  /// 获取推荐的按钮最小高度
  static double getRecommendedMinButtonHeight(BuildContext context) {
    if (isTouchDevice(context)) {
      return 48.0;
    }
    return 40.0; // TV 设备可以使用更小的按钮
  }

  /// 获取推荐的列表项最小高度
  static double getRecommendedMinListItemHeight(BuildContext context) {
    if (isTouchDevice(context)) {
      return 56.0;
    }
    return 48.0;
  }

  /// 获取推荐的卡片最小高度
  static double getRecommendedMinCardHeight(BuildContext context) {
    if (isTouchDevice(context)) {
      return 72.0;
    }
    return 60.0;
  }

  /// 创建带涟漪效果的装饰
  static BoxDecoration createRippleDecoration({
    required Color color,
    BorderRadius? borderRadius,
  }) {
    return BoxDecoration(
      borderRadius: borderRadius,
      color: color.withValues(alpha: 0.1),
    );
  }

  /// 创建触摸感知的焦点装饰
  static BoxBorder? createTouchAwareFocusBorder({
    required BuildContext context,
    required bool hasFocus,
  }) {
    if (!hasFocus) return null;

    if (isTouchDevice(context)) {
      // 触摸设备上使用更小的边框
      return Border.all(
        color: context.theme.colorScheme.primary.withValues(alpha: 0.3),
        width: 1.0,
      );
    }

    // TV 设备上使用更大的边框
    return Border.all(
      color: context.theme.colorScheme.primary,
      width: 3.0,
    );
  }

  /// 创建触摸感知的阴影
  static List<BoxShadow> createTouchAwareShadow({
    required BuildContext context,
    required bool hasFocus,
  }) {
    if (!hasFocus) {
      return [
        BoxShadow(
          color: Colors.black.withValues(alpha: 0.1),
          blurRadius: 4,
          offset: const Offset(0, 2),
        ),
      ];
    }

    if (isTouchDevice(context)) {
      // 触摸设备上使用较小的阴影
      return [
        BoxShadow(
          color: context.theme.colorScheme.primary.withValues(alpha: 0.2),
          blurRadius: 8,
          offset: const Offset(0, 4),
        ),
      ];
    }

    // TV 设备上使用较大的阴影
    return [
      BoxShadow(
        color: context.theme.colorScheme.primary.withValues(alpha: 0.4),
        blurRadius: 16,
        offset: const Offset(0, 8),
      ),
    ];
  }
}

/// 手势感知混入
///
/// 为 State 添加手势管理功能
mixin GestureHelperMixin<T extends StatefulWidget> on State<T> {
  /// 处理点击事件
  void handleTap(VoidCallback? onTap) {
    if (onTap != null) {
      onTap();
    }
  }

  /// 处理长按事件
  void handleLongPress(VoidCallback? onLongPress) {
    if (onLongPress != null) {
      onLongPress();
    }
  }

  /// 处理双击事件
  void handleDoubleTap(VoidCallback? onDoubleTap) {
    if (onDoubleTap != null) {
      onDoubleTap();
    }
  }

  /// 创建带手势的 Widget
  Widget wrapWithGesture({
    required Widget child,
    VoidCallback? onTap,
    VoidCallback? onLongPress,
    VoidCallback? onDoubleTap,
    BorderRadius? borderRadius,
    Color? splashColor,
    Color? highlightColor,
  }) {
    return GestureHelper.withGesture(
      child: child,
      onTap: onTap,
      onLongPress: onLongPress,
      borderRadius: borderRadius,
      splashColor: splashColor,
      highlightColor: highlightColor,
    );
  }
}

/// 触摸感知的构建器
///
/// 根据设备类型自动调整 UI
class TouchAwareBuilder extends StatelessWidget {
  const TouchAwareBuilder({
    super.key,
    required this.builder,
    this.fallbackBuilder,
  });

  final Widget Function(BuildContext context, bool isTouch) builder;
  final Widget Function(BuildContext context)? fallbackBuilder;

  @override
  Widget build(BuildContext context) {
    final bool isTouch = GestureHelper.isTouchDevice(context);
    return builder(context, isTouch);
  }
}

/// 触摸感知的参数
class TouchAwareParams {
  const TouchAwareParams({
    this.isTouch = false,
    this.enableRipple = true,
    this.enableFeedback = true,
    this.splashColor,
    this.highlightColor,
  });

  final bool isTouch;
  final bool enableRipple;
  final bool enableFeedback;
  final Color? splashColor;
  final Color? highlightColor;
}