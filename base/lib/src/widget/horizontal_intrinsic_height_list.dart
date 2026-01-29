import 'package:base/src/extension/scope_ext.dart';
import 'package:collection/collection.dart';
import 'package:flutter/material.dart';

/// Item构建器
typedef HorizontalIntrinsicHeightListItemBuilder<T> =
    Widget Function(BuildContext context, int index, T itemData);

/// 等高Horizontal列表
class HorizontalIntrinsicHeightList<T> extends StatelessWidget {
  const HorizontalIntrinsicHeightList({
    super.key,
    required this.itemBuilder,
    required this.items,
    this.maxLines = 5,
    this.trailing,
    this.scrollEnabled,
    this.isTakeMaxLines = true,
    this.isIntrinsicHeight = true,
  }) : _spaceBetweenItems = 0.0,
       _leadingLeft = 0.0,
       _trailingRight = 0.0,
       _itemTop = 0.0,
       _itemBottom = 0.0;

  const HorizontalIntrinsicHeightList.itemAutoPadding({
    super.key,
    required this.itemBuilder,
    required this.items,
    this.maxLines = 5,
    this.trailing,
    this.scrollEnabled,
    this.isTakeMaxLines = true,
    this.isIntrinsicHeight = true,
    double spaceBetweenItems = 16.0,
    double leadingLeft = 16.0,
    double trailingRight = 16.0,
    double itemTop = 0.0,
    double itemBottom = 0.0,
  }) : _spaceBetweenItems = spaceBetweenItems,
       _leadingLeft = leadingLeft,
       _trailingRight = trailingRight,
       _itemTop = itemTop,
       _itemBottom = itemBottom;

  /// itemBuilder
  final HorizontalIntrinsicHeightListItemBuilder<T> itemBuilder;

  /// 数据源
  final List<T> items;

  /// 最多[maxLines]个元素
  ///
  /// 当[isTakeMaxLines]为 `false`时不生效
  final int maxLines;

  /// 尾部
  final Widget? trailing;

  /// 是否允许滑动
  final bool? scrollEnabled;

  /// 是否配置最大显示个数
  ///
  /// 默认 `true`
  final bool isTakeMaxLines;

  /// 是否IntrinsicHeight
  final bool isIntrinsicHeight;

  /// 创建Item的Padding
  static EdgeInsets createItemPadding({
    required int index,
    required int length,
    double spaceBetweenItems = 16.0,
    double leadingLeft = 16.0,
    double trailingRight = 16.0,
    double itemTop = 0.0,
    double itemBottom = 0.0,
  }) {
    return EdgeInsets.only(
      left: index == 0 ? leadingLeft : spaceBetweenItems / 2,
      right: index == length - 1 ? trailingRight : spaceBetweenItems / 2,
      top: itemTop,
      bottom: itemBottom,
    );
  }

  /// 间距
  final double _spaceBetweenItems;

  /// 左边距
  final double _leadingLeft;

  /// 右边距
  final double _trailingRight;

  /// item顶部
  final double _itemTop;

  /// item底部
  final double _itemBottom;

  @override
  Widget build(BuildContext context) {
    ScrollPhysics enabledScrollPhysics = const BouncingScrollPhysics(
      parent: AlwaysScrollableScrollPhysics(),
    );
    ScrollPhysics disabledScrollPhysics = const NeverScrollableScrollPhysics();
    late ScrollPhysics physics;
    if (scrollEnabled == null) {
      physics = items.length > 1 ? enabledScrollPhysics : disabledScrollPhysics;
    } else if (scrollEnabled == true) {
      physics = enabledScrollPhysics;
    } else if (scrollEnabled == false) {
      physics = disabledScrollPhysics;
    }
    Iterable<T> children = isTakeMaxLines ? items.take(maxLines) : items;
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      physics: physics,
      child:
          Row(
            children:
                children.mapIndexed<Widget>((int index, T item) {
                  return Padding(
                    padding: createItemPadding(
                      index: index,
                      length: children.length,
                      leadingLeft: _leadingLeft,
                      trailingRight: _trailingRight,
                      spaceBetweenItems: _spaceBetweenItems,
                      itemTop: _itemTop,
                      itemBottom: _itemBottom,
                    ),
                    child: itemBuilder.call(context, index, item),
                  );
                }).toList()..addAll([
                  if (trailing != null && items.length >= maxLines) trailing!,
                ]),
          ).let((it) {
            if (isIntrinsicHeight) {
              return IntrinsicHeight(child: it);
            }
            return it;
          }),
    );
  }
}
