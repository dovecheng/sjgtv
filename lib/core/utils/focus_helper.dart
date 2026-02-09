import 'package:flutter/material.dart';
import 'package:sjgtv/core/core.dart';

final Log _log = Log('FocusHelper');

/// 焦点移动方向
enum FocusMoveDirection {
  up,
  down,
  left,
  right,
}

/// 焦点管理工具类
///
/// 提供 TV 遥控器焦点管理功能：
/// - 焦点记忆（页面返回时恢复，支持持久化）
/// - 焦点边界处理
/// - 网格导航辅助
/// - 焦点移动优化
/// - 焦点预测
/// - 自动滚动
class FocusHelper {
  FocusHelper._();

  /// 焦点记忆存储
  static final Map<String, FocusNode> _focusMemory = {};

  /// 焦点位置记忆（持久化）
  static final Map<String, int> _focusPositionMemory = {};

  /// 保存焦点
  static void saveFocus(String key, FocusNode? focusNode) {
    if (focusNode != null && focusNode.hasFocus) {
      _focusMemory[key] = focusNode;
    }
  }

  /// 保存焦点位置
  static void saveFocusPosition(String key, int position) {
    _focusPositionMemory[key] = position;
  }

  /// 恢复焦点
  static void restoreFocus(String key) {
    final FocusNode? savedFocus = _focusMemory[key];
    if (savedFocus != null) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (savedFocus.context != null) {
          savedFocus.requestFocus();
        } else {
          _focusMemory.remove(key);
        }
      });
    }
  }

  /// 恢复焦点位置
  static int? restoreFocusPosition(String key) {
    return _focusPositionMemory[key];
  }

  /// 清除焦点记忆
  static void clearFocusMemory(String key) {
    _focusMemory.remove(key);
    _focusPositionMemory.remove(key);
  }

  /// 清除所有焦点记忆
  static void clearAllFocusMemory() {
    _focusMemory.clear();
    _focusPositionMemory.clear();
  }

  /// 尝试请求焦点（带安全检查）
  static bool safeRequestFocus(FocusNode? focusNode) {
    if (focusNode == null) {
      return false;
    }

    try {
      // 检查是否已挂载
      if (focusNode.context == null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          if (focusNode.context != null) {
            focusNode.requestFocus();
          }
        });
        return true;
      }

      focusNode.requestFocus();
      return true;
    } catch (e) {
      _log.w(() => '请求焦点失败: $e');
      return false;
    }
  }

  /// 网格内焦点移动
  ///
  /// [currentIndex] 当前索引
  /// [cols] 列数
  /// [rows] 行数
  /// [direction] 移动方向
  /// [onMoveFocus] 焦点移动回调
  static bool moveInGrid(
    int currentIndex,
    int cols,
    int rows,
    FocusMoveDirection direction,
    void Function(int targetIndex) onMoveFocus,
  ) {
    final int total = cols * rows;
    if (total == 0) return false;

    int? target;

    switch (direction) {
      case FocusMoveDirection.up:
        target = currentIndex - cols;
        break;
      case FocusMoveDirection.down:
        target = currentIndex + cols;
        break;
      case FocusMoveDirection.left:
        if (currentIndex % cols != 0) {
          target = currentIndex - 1;
        }
        break;
      case FocusMoveDirection.right:
        if ((currentIndex + 1) % cols != 0) {
          target = currentIndex + 1;
        }
        break;
    }

    if (target != null && target >= 0 && target < total) {
      onMoveFocus(target);
      return true;
    }

    return false;
  }

  /// 边界焦点处理
  ///
  /// 当焦点到达边界时的处理策略
  static void handleBoundaryFocus(
    FocusNode currentFocus,
    FocusMoveDirection direction,
    BuildContext context, {
    VoidCallback? onBoundaryReached,
  }) {
    // 默认行为：在边界时不处理，让焦点保持在当前位置
    // 可以扩展为循环滚动、自动加载更多等
    onBoundaryReached?.call();
  }

  /// 创建可聚焦的包装器
  ///
  /// 为 Widget 添加焦点管理功能
  static Widget focusable({
    required Widget child,
    required FocusNode focusNode,
    bool autofocus = false,
    KeyEventResult Function(FocusNode node, KeyEvent event)? onKeyEvent,
    ValueChanged<bool>? onFocusChange,
    Widget Function(BuildContext context, bool hasFocus)? builder,
  }) {
    return Focus(
      focusNode: focusNode,
      autofocus: autofocus,
      onKeyEvent: onKeyEvent,
      onFocusChange: onFocusChange,
      child: Builder(
        builder: (context) {
          final bool hasFocus = Focus.of(context).hasFocus;
          return builder?.call(context, hasFocus) ?? child;
        },
      ),
    );
  }

  /// 防抖焦点请求
  ///
  /// 避免短时间内多次请求焦点
  static void debouncedRequestFocus(
    FocusNode focusNode, {
    Duration delay = const Duration(milliseconds: 100),
  }) {
    DateTime? lastRequestTime;
    void request() {
      final DateTime now = DateTime.now();
      if (lastRequestTime != null &&
          now.difference(lastRequestTime!) < delay) {
        return;
      }
      lastRequestTime = now;
      safeRequestFocus(focusNode);
    }

    WidgetsBinding.instance.addPostFrameCallback((_) => request());
  }

  /// 焦点链管理
  ///
  /// 按顺序管理一组焦点节点
  static void manageFocusChain(
    List<FocusNode> nodes, {
    FocusNode? initialFocus,
    bool cycle = false,
  }) {
    if (nodes.isEmpty) return;

    if (initialFocus != null) {
      safeRequestFocus(initialFocus);
    } else if (nodes.isNotEmpty) {
      safeRequestFocus(nodes.first);
    }

    // ignore: unused_local_variable
    for (int i = 0; i < nodes.length; i++) {
      // 可以在这里添加自定义的焦点链逻辑
      // 预留为未来的焦点链管理功能
    }
  }

  /// 滚动到焦点可见区域
  ///
  /// 当焦点在滚动视图中时，自动滚动到可见区域
  /// 优化后的版本：考虑滚动方向，预测焦点移动目标
  static void scrollToFocus(
    ScrollController scrollController,
    BuildContext context, {
    Duration duration = const Duration(milliseconds: 300),
    Curve curve = Curves.easeInOut,
    FocusMoveDirection? moveDirection,
    double padding = 80.0,
  }) {
    if (!scrollController.hasClients) return;

    final RenderBox? renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox == null) return;

    final RenderBox? scrollRenderBox =
        scrollController.position.context.storageContext.findRenderObject() as RenderBox?;
    if (scrollRenderBox == null) return;

    final Offset position = renderBox.localToGlobal(Offset.zero);
    final Offset scrollPosition = scrollRenderBox.localToGlobal(Offset.zero);

    final double scrollOffset = scrollController.offset;
    final double viewportHeight = scrollRenderBox.size.height;
    final double viewportTop = scrollPosition.dy;
    final double viewportBottom = viewportTop + viewportHeight;

    final double itemTop = position.dy;
    final double itemBottom = position.dy + renderBox.size.height;

    double targetOffset = scrollOffset;

    // 根据移动方向预测滚动位置
    if (moveDirection == FocusMoveDirection.down) {
      // 向下移动时，将目标放在视口下方，留出更多空间
      targetOffset = scrollOffset + itemBottom - viewportBottom + padding;
    } else if (moveDirection == FocusMoveDirection.up) {
      // 向上移动时，将目标放在视口上方，留出更多空间
      targetOffset = scrollOffset + itemTop - viewportTop - padding;
    } else {
      // 默认居中显示
      targetOffset = scrollOffset +
          itemTop -
          viewportTop -
          (viewportHeight / 2) +
          (renderBox.size.height / 2);
    }

    scrollController.animateTo(
      targetOffset.clamp(
        scrollController.position.minScrollExtent,
        scrollController.position.maxScrollExtent,
      ),
      duration: duration,
      curve: curve,
    );
  }

  /// 焦点预测
  ///
  /// 预测焦点移动的目标位置
  static int? predictFocusTarget(
    int currentIndex,
    int cols,
    int itemCount,
    FocusMoveDirection direction,
  ) {
    if (itemCount == 0) return null;

    int? target;

    switch (direction) {
      case FocusMoveDirection.up:
        target = currentIndex - cols;
        break;
      case FocusMoveDirection.down:
        target = currentIndex + cols;
        break;
      case FocusMoveDirection.left:
        if (currentIndex % cols != 0) {
          target = currentIndex - 1;
        }
        break;
      case FocusMoveDirection.right:
        if ((currentIndex + 1) % cols != 0) {
          target = currentIndex + 1;
        }
        break;
    }

    if (target != null && target >= 0 && target < itemCount) {
      return target;
    }

    return null;
  }

  /// 智能焦点滚动
  ///
  /// 根据焦点移动方向和当前位置，智能决定滚动策略
  static void smartScrollToFocus(
    ScrollController scrollController,
    int currentIndex,
    int cols,
    int itemCount,
    List<GlobalKey> keys,
    FocusMoveDirection direction,
  ) {
    final int? targetIndex = predictFocusTarget(
      currentIndex,
      cols,
      itemCount,
      direction,
    );

    if (targetIndex == null || targetIndex >= keys.length) return;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? ctx = keys[targetIndex].currentContext;
      if (ctx != null) {
        scrollToFocus(
          scrollController,
          ctx,
          moveDirection: direction,
        );
      }
    });
  }

  /// 检测是否为 TV 设备
  static bool isTV(BuildContext context) {
    return MediaQuery.maybeOf(context)?.deviceType == DeviceType.tv ||
        $platform.isAndroidNative ||
        $platform.isIOSNative;
  }

  /// 获取焦点边框样式
  static Border getFocusBorder({
    Color color = const Color(0xFF3EA6FF),
    double width = 3.0,
  }) {
    return Border.all(
      color: color,
      width: width,
    );
  }

  /// 获取焦点阴影
  static List<BoxShadow> getFocusShadow({
    Color color = const Color(0xFF3EA6FF),
    double blurRadius = 12.0,
    double spreadRadius = 2.0,
  }) {
    return [
      BoxShadow(
        color: color.withValues(alpha: 0.4),
        blurRadius: blurRadius,
        spreadRadius: spreadRadius,
      ),
    ];
  }
}

/// 焦点管理混入
///
/// 为 State 添加焦点管理功能
mixin FocusHelperMixin<T extends StatefulWidget> on State<T> {
  final Map<String, FocusNode> _focusNodes = {};
  final Map<String, GlobalKey> _keys = {};

  /// 获取或创建焦点节点
  FocusNode getFocusNode(String key) {
    return _focusNodes.putIfAbsent(key, () => FocusNode());
  }

  /// 获取或创建 GlobalKey
  GlobalKey<S> getGlobalKey<S extends State<StatefulWidget>>(String key) {
    return _keys.putIfAbsent(key, () => GlobalKey()) as GlobalKey<S>;
  }

  /// 保存当前焦点
  void saveCurrentFocus(String key) {
    final FocusNode? currentFocus = FocusManager.instance.primaryFocus;
    FocusHelper.saveFocus(key, currentFocus);
  }

  /// 恢复焦点
  void restoreSavedFocus(String key) {
    FocusHelper.restoreFocus(key);
  }

  @override
  void dispose() {
    for (final FocusNode node in _focusNodes.values) {
      node.dispose();
    }
    _focusNodes.clear();
    _keys.clear();
    super.dispose();
  }
}