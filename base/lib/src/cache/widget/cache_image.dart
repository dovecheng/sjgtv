import 'package:base/cache.dart';
import 'package:base/env.dart';
import 'package:base/log.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:stack_trace/stack_trace.dart';

/// 为[CachedNetworkImage]配置缓存管理[CacheManager]
///
/// 使用缓存管理器 [cacheProvider]
class CachedImage extends CachedNetworkImage {
  CachedImage({
    super.key,
    required super.imageUrl,
    super.httpHeaders,
    super.imageBuilder,
    super.placeholder,
    super.progressIndicatorBuilder,
    LoadingErrorWidgetBuilder? errorWidget,
    super.fadeOutDuration = const Duration(milliseconds: 1000),
    super.fadeOutCurve = Curves.easeOut,
    super.fadeInDuration = const Duration(milliseconds: 500),
    super.fadeInCurve = Curves.easeIn,
    super.width,
    super.height,
    super.fit,
    super.alignment = Alignment.center,
    super.repeat = ImageRepeat.noRepeat,
    super.matchTextDirection = false,
    super.cacheManager,
    super.useOldImageOnUrlChange = false,
    super.color,
    super.filterQuality = FilterQuality.low,
    super.colorBlendMode,
    super.placeholderFadeInDuration,
    int? memCacheWidth,
    int? memCacheHeight,
    super.cacheKey,
    super.maxWidthDiskCache,
    super.maxHeightDiskCache,
    ValueChanged<Object>? errorListener,
    super.imageRenderMethodForWeb = ImageRenderMethodForWeb.HtmlImage,

    /// 是否添加默认的memCache
    bool addDefaultMemCache = true,
  }) : super(
         memCacheWidth:
             memCacheWidth ??
             (addDefaultMemCache ? (width?.toCachedImageSize()) : null),
         memCacheHeight:
             memCacheHeight ??
             (addDefaultMemCache ? (height?.toCachedImageSize()) : null),
         errorWidget: errorWidget ?? _defaultErrorWidget(width, height),
         errorListener: _wrapErrorListener(
           imageUrl,
           Frame.caller().location,
           errorListener,
         ),
       );

  static LoadingErrorWidgetBuilder? _defaultErrorWidget(
    double? width,
    double? height,
  ) => !kReleaseMode || width != null || height != null
      ? (BuildContext context, String url, Object error) {
          if (!kReleaseMode) {
            return Stack(
              alignment: Alignment.center,
              children: [
                Positioned.fill(child: Placeholder(color: Colors.red.shade900)),
                Padding(
                  padding: const EdgeInsets.all(4.0),
                  child: FittedBox(child: Text('$error')),
                ),
              ],
            );
          } else {
            return SizedBox(width: width, height: height);
          }
        }
      : null;

  static ValueChanged<Object> _wrapErrorListener(
    String imageUrl,
    String callerLocation,
    ValueChanged<Object>? errorListener,
  ) => (error) {
    Log log = Log('CachedImage');
    log.w(() => '$callerLocation, $imageUrl', error);
    errorListener?.call(error);
  };
}
