import 'package:base/src/widget/context_padding_extension.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

/// 配置异形屏底部高度-sliver
///
/// 页面底部【没有特殊Widget需要紧贴屏幕底部】时可使用
///
/// MediaQuery.paddingOf(this).bottom 键盘弹起时会变为0
class SafeSliverPaddingBottom extends SingleChildRenderObjectWidget {
  const SafeSliverPaddingBottom({
    super.key,
    this.minPaddingBottom = 16.0,
    this.useAndroidSafeArea = true,
    Widget? sliver,
  }) : super(child: sliver);

  final double minPaddingBottom;
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
      DiagnosticsProperty<double>('minPaddingBottom', minPaddingBottom),
    );
  }

  EdgeInsetsGeometry _getPadding(BuildContext context) {
    double bottom = context.getMediaQueryPaddingBottom(
      minPaddingBottom: minPaddingBottom,
      useAndroidSafeArea: useAndroidSafeArea,
    );
    return EdgeInsets.only(bottom: bottom);
  }
}
