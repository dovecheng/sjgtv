import 'package:base/cache.dart';
import 'package:base/extension.dart';
import 'package:base/l10n.dart';
import 'package:flutter/material.dart';

class ApiEmptyWidget extends StatelessWidget {
  const ApiEmptyWidget({
    super.key,
    this.networkImageUrl,
    required this.assetsImage,
    this.imageSize = 128,
    this.onTap,
    this.imageColor,
    this.scrollable = false,
    this.padding = EdgeInsets.zero,
    this.text,
    this.text10nKey,
    this.textStyle,
  });

  /// 网络图片地址
  final String? networkImageUrl;

  /// assetsImage
  final String assetsImage;

  /// 图片/图标 Size
  final double imageSize;

  /// 空白标题
  final String? text;

  /// text国际化key
  final String? text10nKey;

  /// 空白标题样式
  final TextStyle? textStyle;

  /// 点击事件
  final GestureTapCallback? onTap;

  /// 图片/图标 颜色
  final Color? imageColor;

  /// 是否可滑动的, 可用于配合下拉刷新控件.
  final bool scrollable;

  /// padding
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    if (scrollable) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          Size size = MediaQuery.sizeOf(context);
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              width: constraints.constrainWidth(size.width),
              height: constraints.constrainHeight(size.height),
              child: buildWidget(context),
            ),
          );
        },
      );
    } else {
      return buildWidget(context);
    }
  }

  Widget buildWidget(BuildContext context) => EmptyBaseWidget(
    networkImageUrl: networkImageUrl,
    assetsImage: assetsImage,
    imageSize: imageSize,
    imageColor: imageColor,
    onTap: onTap,
    padding: padding,
    textStyle: textStyle,
    text: text,
    text10nKey: text10nKey,
  );
}

class ApiErrorWidget extends StatelessWidget {
  const ApiErrorWidget({
    super.key,
    this.networkImageUrl,
    required this.assetsImage,
    this.imageSize = 128,
    this.text,
    this.textStyle,
    this.onTap,
    this.text10nKey,
    this.imageColor,
    this.scrollable = false,
    this.padding = EdgeInsets.zero,
  });

  /// 网络图片地址
  final String? networkImageUrl;

  /// assetsImage
  final String assetsImage;

  /// 图片/图标 Size
  final double imageSize;

  /// 点击事件
  final GestureTapCallback? onTap;

  /// 图片/图标 颜色
  final Color? imageColor;

  /// 空白标题
  final String? text;

  /// text国际化key
  final String? text10nKey;

  /// 空白标题样式
  final TextStyle? textStyle;

  /// 是否可滑动的, 可用于配合下拉刷新控件.
  final bool scrollable;

  /// padding
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    if (scrollable) {
      return LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          Size size = MediaQuery.sizeOf(context);
          return SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            child: SizedBox(
              width: constraints.constrainWidth(size.width),
              height: constraints.constrainHeight(size.height),
              child: buildWidget(context),
            ),
          );
        },
      );
    } else {
      return buildWidget(context);
    }
  }

  Widget buildWidget(BuildContext context) => EmptyBaseWidget(
    networkImageUrl: networkImageUrl,
    assetsImage: assetsImage,
    imageSize: imageSize,
    text: text,
    text10nKey: text10nKey,
    textStyle: textStyle,
    imageColor: imageColor,
    onTap: onTap,
    padding: padding,
  );
}

/// base EmptyWidget
class EmptyBaseWidget extends StatelessWidget {
  const EmptyBaseWidget({
    super.key,
    this.networkImageUrl,
    required this.assetsImage,
    this.imageSize = 56,
    this.text,
    this.textStyle,
    this.onTap,
    this.text10nKey,
    this.imageColor,
    this.padding = EdgeInsets.zero,
  });

  /// 网络图片地址
  final String? networkImageUrl;

  /// assetsImage
  final String assetsImage;

  /// 图片/图标 Size
  final double imageSize;

  /// 空白标题
  final String? text;

  /// text国际化key
  final String? text10nKey;

  /// 空白标题样式
  final TextStyle? textStyle;

  /// 点击事件
  final GestureTapCallback? onTap;

  /// 图片/图标 颜色
  final Color? imageColor;

  /// padding
  final EdgeInsets padding;

  @override
  Widget build(BuildContext context) {
    Image defaultAssetsImage = Image.asset(
      assetsImage,
      width: imageSize,
      height: imageSize,
      color: imageColor,
      cacheWidth: imageSize.toCachedImageSize(),
      cacheHeight: imageSize.toCachedImageSize(),
    );

    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: padding,
        child: Center(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (networkImageUrl?.isNotEmpty == true)
                CachedImage(
                  imageUrl: networkImageUrl!,
                  errorWidget: (context, url, error) {
                    return defaultAssetsImage;
                  },
                  placeholder: (context, url) {
                    return defaultAssetsImage;
                  },
                  width: imageSize,
                  height: imageSize,
                  color: imageColor,
                )
              else if (assetsImage.isNotEmpty == true)
                defaultAssetsImage,
              if (text?.isNotEmpty == true) ...[
                const SizedBox(height: 4),
                Text(text!, style: textStyle, textAlign: TextAlign.center).let((
                  Text it,
                ) {
                  if (text10nKey?.isNotEmpty == true) {
                    return L10nKeyTips(keyTips: text10nKey, child: it);
                  }
                  return it;
                }),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
