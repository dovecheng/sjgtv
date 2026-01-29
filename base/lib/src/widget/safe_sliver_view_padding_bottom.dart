import 'package:base/src/widget/context_padding_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 配置异形屏底部高度-sliver
///
/// 页面底部【没有特殊Widget需要紧贴屏幕底部】时可使用
///
/// MediaQuery.viewPaddingOf(context).bottom 键盘弹起时保持不变
class SafeSliverViewPaddingBottom extends SingleChildRenderObjectWidget {
  const SafeSliverViewPaddingBottom({
    super.key,
    this.minViewPaddingBottom = 16.0,
    this.useAndroidSafeArea = true,
    Widget? sliver,
  }) : super(child: sliver);

  final double minViewPaddingBottom;
  final bool useAndroidSafeArea;
  @override
  RenderSliverPadding createRenderObject(BuildContext context) {
    EdgeInsetsGeometry padding = _getPadding(context);
    return RenderSliverPadding(
      padding: padding,
      textDirection: Directionality.of(context),
    );
  }

  @override
  void updateRenderObject(
    BuildContext context,
    RenderSliverPadding renderObject,
  ) {
    EdgeInsetsGeometry padding = _getPadding(context);
    renderObject
      ..padding = padding
      ..textDirection = Directionality.of(context);
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(
      DiagnosticsProperty<double>('minViewPaddingBottom', minViewPaddingBottom),
    );
  }

  EdgeInsetsGeometry _getPadding(BuildContext context) {
    double bottom = context.getMediaQueryViewPaddingBottom(
      minViewPaddingBottom: minViewPaddingBottom,
      useAndroidSafeArea: useAndroidSafeArea,
    );
    return EdgeInsets.only(bottom: bottom);
  }
}
