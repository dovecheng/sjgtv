import 'package:base/extension.dart';
import 'package:flutter/material.dart';

/// 安卓设备添加SafeArea(不包含top)
///
/// 安卓11以上可能默认底部没有安全区域，导致底部导航条遮挡问题
class AndroidSafeArea extends StatelessWidget {
  final Widget child;

  const AndroidSafeArea({super.key, required this.child});

  @override
  Widget build(BuildContext context) => child.let(
    (Widget it) => $platform.isAndroidNative
        ? SafeArea(
            top: false, // remove top
            child: child,
          )
        : it,
  );
}
