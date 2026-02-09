import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

typedef CacheImageProviderWidgetBuilder =
    Widget Function(
      BuildContext context,
      CacheImageProviderBuilderState state,
      Widget? child,
    );

/// 具有背景图片的容器构建器
///
/// 构建 [DecorationImage] 提供 [DecorationImage.onError]
class CacheImageProviderBuilder extends StatefulWidget {
  /// 构建控件
  final CacheImageProviderWidgetBuilder builder;

  /// 传递子控件
  final Widget? child;

  /// 图片加载构建器
  ///
  /// [builder] 构建加载图片的控件
  ///
  /// [child] 要传递给[builder]的子控件
  const CacheImageProviderBuilder({
    super.key,
    required this.builder,
    this.child,
  });

  @override
  State<CacheImageProviderBuilder> createState() =>
      CacheImageProviderBuilderState();
}

/// 图片加载状态
class CacheImageProviderBuilderState extends State<CacheImageProviderBuilder> {
  bool _isError = false;

  /// 标记是否加载失败
  ///
  /// 如果加载失败改为使用[AssetImage], 而不是[CachedNetworkImageProvider]
  bool get isError => _isError;

  @override
  Widget build(BuildContext context) =>
      widget.builder(context, this, widget.child);

  /// 切换错误状态
  void onError() {
    if (isError) {
      return;
    }
    _isError = true;
    setState(() {});
  }
}
