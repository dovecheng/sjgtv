import 'package:base/src/widget/context_padding_extension.dart';
import 'package:flutter/material.dart';

/// 配置异形屏底部高度
///
/// 页面底部【没有特殊Widget需要紧贴屏幕底部】时可使用
///
/// MediaQuery.viewPaddingOf(context).bottom 键盘弹起时保持不变
class SafeViewPaddingBottom extends StatelessWidget {
  const SafeViewPaddingBottom({
    super.key,
    this.child,
    this.minViewPaddingBottom = 16.0,
    this.useAndroidSafeArea = true,
  });

  final Widget? child;
  final double minViewPaddingBottom;
  final bool useAndroidSafeArea;
  @override
  Widget build(BuildContext context) {
    double bottom = context.getMediaQueryViewPaddingBottom(
      minViewPaddingBottom: minViewPaddingBottom,
      useAndroidSafeArea: useAndroidSafeArea,
    );
    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: child,
    );
  }
}
