import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';

/// 电视优化的自定义页面过渡动画
///
/// 特性：
/// - 从右侧滑入
/// - 淡入效果
/// - 适合电视遥控器操作
class TVPageTransition extends Page<dynamic> {
  const TVPageTransition({
    required this.child,
    super.key,
    super.name,
    super.arguments,
  });

  final Widget child;

  @override
  Route<dynamic> createRoute(BuildContext context) {
    return PageRouteBuilder<dynamic>(
      settings: this,
      transitionDuration: 400.ms,
      reverseTransitionDuration: 300.ms,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(0.08, 0),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}

/// 缩放页面过渡动画
///
/// 特性：
/// - 从中心缩放
/// - 淡入效果
/// - 适合模态对话框
class ScalePageTransition extends Page<dynamic> {
  const ScalePageTransition({
    required this.child,
    super.key,
    super.name,
    super.arguments,
  });

  final Widget child;

  @override
  Route<dynamic> createRoute(BuildContext context) {
    return PageRouteBuilder<dynamic>(
      settings: this,
      transitionDuration: 300.ms,
      reverseTransitionDuration: 200.ms,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return ScaleTransition(
          scale: Tween<double>(begin: 0.95, end: 1.0).animate(
            CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
          ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}

/// 淡入淡出页面过渡动画
///
/// 特性：
/// - 纯淡入淡出效果
/// - 适合简单页面切换
class FadePageTransition extends Page<dynamic> {
  const FadePageTransition({
    required this.child,
    super.key,
    super.name,
    super.arguments,
  });

  final Widget child;

  @override
  Route<dynamic> createRoute(BuildContext context) {
    return PageRouteBuilder<dynamic>(
      settings: this,
      transitionDuration: 250.ms,
      reverseTransitionDuration: 200.ms,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return FadeTransition(opacity: animation, child: child);
      },
    );
  }
}

/// 播放器页面过渡动画
///
/// 特性：
/// - 从底部滑入
/// - 全屏沉浸式
/// - 适合视频播放页面
class PlayerPageTransition extends Page<dynamic> {
  const PlayerPageTransition({
    required this.child,
    super.key,
    super.name,
    super.arguments,
  });

  final Widget child;

  @override
  Route<dynamic> createRoute(BuildContext context) {
    return PageRouteBuilder<dynamic>(
      settings: this,
      transitionDuration: 350.ms,
      reverseTransitionDuration: 250.ms,
      fullscreenDialog: true,
      pageBuilder: (context, animation, secondaryAnimation) => child,
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        return SlideTransition(
          position:
              Tween<Offset>(
                begin: const Offset(0, 0.15),
                end: Offset.zero,
              ).animate(
                CurvedAnimation(parent: animation, curve: Curves.easeOutCubic),
              ),
          child: FadeTransition(opacity: animation, child: child),
        );
      },
    );
  }
}
