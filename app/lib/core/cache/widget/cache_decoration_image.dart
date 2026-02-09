import '../../../core/cache.dart';
import '../../../core/log.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:stack_trace/stack_trace.dart';

/// 监听背景图片加载错误和刷新状态[CacheImageProviderBuilderState.onError]
///
/// 如直接使用[DecorationImage]并不传递[onError]参数
/// 会报SDK错误, 参见: [ImageStreamCompleter.addListener]
class CacheDecorationImage extends DecorationImage {
  CacheDecorationImage({
    required super.image,
    CacheImageProviderBuilderState? state,
    ImageErrorListener? onError,
    super.colorFilter,
    super.fit,
    super.alignment = Alignment.center,
    super.centerSlice,
    super.repeat = ImageRepeat.noRepeat,
    super.matchTextDirection = false,
    super.scale = 1.0,
    super.opacity = 1.0,
    super.filterQuality = FilterQuality.low,
    super.invertColors = false,
    super.isAntiAlias = false,
  }) : super(
         onError: _wrapOnError(image, Frame.caller().location, state, onError),
       );

  static ImageErrorListener _wrapOnError(
    ImageProvider<Object> image,
    String callerLocation,
    CacheImageProviderBuilderState? state,
    ImageErrorListener? onError,
  ) => (Object exception, StackTrace? stackTrace) {
    Log log = Log('CacheDecorationImage');
    log.w(
      () =>
          '${switch (image) {
            CachedNetworkImageProvider _ => image.url,
            NetworkImage _ => image.url,
            AssetImage _ => image.keyName,
            ExactAssetImage _ => image.keyName,
            FileImage _ => image.file.path,
            _ => null,
          }}, $callerLocation',
      exception,
      stackTrace,
    );
    state?.onError();
    onError?.call(exception, stackTrace);
  };
}
