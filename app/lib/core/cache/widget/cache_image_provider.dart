import '../../../core/cache.dart';
import '../../../core/log.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:cached_network_image_platform_interface/cached_network_image_platform_interface.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';
import 'package:stack_trace/stack_trace.dart';

/// 为[CachedNetworkImageProvider]配置缓存管理[CacheManager]
///
/// 使用缓存管理器 [cacheProvider]
class CacheImageProvider extends CachedNetworkImageProvider {
  CacheImageProvider(
    super.url, {
    CacheImageProviderBuilderState? state,
    super.maxHeight,
    super.maxWidth,
    super.scale = 1.0,
    ErrorListener? errorListener,
    super.headers,
    super.cacheManager,
    super.cacheKey,
    super.imageRenderMethodForWeb = ImageRenderMethodForWeb.HtmlImage,
  }) : super(
         errorListener: _wrapErrorListener(
           url,
           Frame.caller().location,
           state,
           errorListener,
         ),
       );

  static ErrorListener _wrapErrorListener(
    String url,
    String callerLocation,
    CacheImageProviderBuilderState? state,
    ErrorListener? errorListener,
  ) => (Object error) {
    Log log = Log('CacheImageProvider');
    log.w(() => '$url, $callerLocation', error);
    state?.onError();
    errorListener?.call(error);
  };
}
