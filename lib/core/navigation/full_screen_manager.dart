import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:sjgtv/core/responsive/responsive_layout.dart';

/// 全屏管理器
///
/// 管理应用的全屏状态，支持 TV 自动全屏和其他设备手动全屏
class FullScreenManager {
  FullScreenManager._();

  static FullScreenManager? _instance;
  static FullScreenManager get instance {
    _instance ??= FullScreenManager._();
    return _instance!;
  }

  bool _isFullScreen = false;

  /// 是否处于全屏状态
  bool get isFullScreen => _isFullScreen;

  /// 进入全屏模式
  Future<void> enterFullScreen() async {
    if (_isFullScreen) return;

    // 隐藏状态栏
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

    // 设置首选方向
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _isFullScreen = true;
  }

  /// 退出全屏模式
  Future<void> exitFullScreen() async {
    if (!_isFullScreen) return;

    // 显示状态栏和导航栏
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.edgeToEdge,
      overlays: SystemUiOverlay.values,
    );

    // 恢复所有方向
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    _isFullScreen = false;
  }

  /// 切换全屏状态
  Future<void> toggleFullScreen() async {
    if (_isFullScreen) {
      await exitFullScreen();
    } else {
      await enterFullScreen();
    }
  }

  /// 根据设备类型自动设置全屏
  ///
  /// TV 自动进入全屏，其他设备保持窗口模式
  static Future<void> setupForDevice(BuildContext context) async {
    if (context.shouldAutoFullScreen) {
      await instance.enterFullScreen();
    } else {
      await instance.exitFullScreen();
    }
  }

  /// 重置全屏状态
  Future<void> reset() async {
    await exitFullScreen();
  }
}

/// 全屏状态监听器
class FullScreenListener extends StatefulWidget {
  const FullScreenListener({
    super.key,
    required this.child,
    this.onFullScreenChanged,
  });

  final Widget child;
  final ValueChanged<bool>? onFullScreenChanged;

  @override
  State<FullScreenListener> createState() => _FullScreenListenerState();
}

class _FullScreenListenerState extends State<FullScreenListener> {
  @override
  void initState() {
    super.initState();
    FullScreenManager.instance._isFullScreen = false;
  }

  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
