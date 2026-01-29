import 'package:base/log.dart';
import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

/// 列表页面骨架
///
/// see: [Shimmer](https://pub.dev/packages/shimmer)
class ListSkeleton extends StatelessWidget {
  /// 如果为`null`, 默认为[NeverScrollableScrollPhysics]
  final ScrollPhysics? physics;

  const ListSkeleton({super.key, this.physics});

  @override
  Widget build(BuildContext context) => LayoutBuilder(
    builder: (BuildContext context, BoxConstraints constraints) {
      log.d(null);

      // 计算布局可用高度
      double deviceHeight = MediaQuery.sizeOf(context).height;
      double constrainHeight = constraints.constrainHeight(deviceHeight);

      return Shimmer.fromColors(
        baseColor: Colors.grey.shade300,
        highlightColor: Colors.grey.shade200,
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListView.separated(
            shrinkWrap: true,
            physics: physics ?? const NeverScrollableScrollPhysics(),
            itemCount: (constrainHeight - 16) ~/ 52,
            itemBuilder: (BuildContext context, int index) =>
                const _ListSkeletonItem(),
            separatorBuilder: (BuildContext context, int index) =>
                const SizedBox(height: 8),
          ),
        ),
      );
    },
  );
}

/// 骨架屏 Item
class _ListSkeletonItem extends StatelessWidget {
  const _ListSkeletonItem();

  @override
  Widget build(BuildContext context) => Row(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Container(color: Colors.white, width: 48, height: 48),
      const SizedBox(width: 8),
      Expanded(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(color: Colors.white, width: double.infinity, height: 8),
            const SizedBox(height: 8),
            FractionallySizedBox(
              widthFactor: 0.6,
              child: Container(color: Colors.white, height: 8),
            ),
            const SizedBox(height: 8),
            FractionallySizedBox(
              widthFactor: 0.2,
              child: Container(color: Colors.white, height: 8),
            ),
          ],
        ),
      ),
    ],
  );
}
