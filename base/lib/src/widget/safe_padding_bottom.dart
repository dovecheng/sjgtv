import 'package:base/src/widget/context_padding_extension.dart';
import 'package:flutter/material.dart';

/// 配置异形屏底部高度
///
/// 页面底部【没有特殊Widget需要紧贴屏幕底部】时可使用
///
/// MediaQuery.paddingOf(this).bottom 键盘弹起时会变为0
class SafePaddingBottom extends StatelessWidget {
  const SafePaddingBottom({
    super.key,
    this.child,
    this.minPaddingBottom = 16.0,
    this.useAndroidSafeArea = true,
  });

  final Widget? child;
  final double minPaddingBottom;
  final bool useAndroidSafeArea;
  @override
  Widget build(BuildContext context) {
    double bottom = context.getMediaQueryPaddingBottom(
      minPaddingBottom: minPaddingBottom,
      useAndroidSafeArea: useAndroidSafeArea,
    );

    return Padding(
      padding: EdgeInsets.only(bottom: bottom),
      child: child,
    );
  }
}
