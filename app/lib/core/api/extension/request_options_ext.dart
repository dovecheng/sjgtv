import 'dart:convert';

import '../../../core/extension.dart';
import '../../../core/log.dart';
import 'package:dio/dio.dart';

extension RequestOptionsCodecExt on RequestOptions {
  /// 记录请求数据大小 字节数
  Future<List<int>> _requestEncoder(
    String request,
    RequestOptions options,
  ) async {
    List<int> encode = utf8.encode(request);
    options.requestBytes = encode.length;
    return encode;
  }

  /// 记录请求数据大小 字节数
  RequestEncoder _requestEncoderProxy(RequestEncoder raw) =>
      (String request, RequestOptions options) async {
        List<int> encode = await raw(request, options);
        options.requestBytes = encode.length;
        return encode;
      };

  /// 记录响应数据大小 字节数
  String _responseDecoder(
    List<int> responseBytes,
    RequestOptions options,
    ResponseBody responseBody,
  ) {
    options.responseBytes = responseBytes.length;
    return utf8.decode(responseBytes, allowMalformed: true);
  }

  /// 记录响应数据大小 字节数
  ResponseDecoder _responseDecoderProxy(ResponseDecoder raw) =>
      (
        List<int> responseBytes,
        RequestOptions options,
        ResponseBody responseBody,
      ) {
        options.responseBytes = responseBytes.length;
        return raw(responseBytes, options, responseBody);
      };

  /// 记录请求数据大小 字节数
  void setupRequestEncoder() => requestEncoder = requestEncoder != null
      ? _requestEncoderProxy(requestEncoder!)
      : _requestEncoder;

  /// 记录响应数据大小 字节数
  void setupResponseDecoder() => responseDecoder = responseDecoder != null
      ? _responseDecoderProxy(responseDecoder!)
      : _responseDecoder;
}

extension RequestToMapExt on RequestOptions {
  /// convert [RequestOptions] to [Map]
  Map<String, dynamic> toMap() => {
    'request.uri': uri,
    if (headers.isNotEmpty) 'request.headers': headers,
    'request.data': isLoggableData && requestBytes < 1024 * 32
        ? data
        : '${formatBytesSize(requestBytes)} ${data.runtimeType}',
    if (extra.isNotEmpty) 'request.extra': extra,
    if (hasResponse) 'request.elapsed': '${elapsedTime?.inMilliseconds}ms',
    'request.cancelToken': cancelToken?.let(
      (CancelToken it) =>
          '${it.shortHash}${it.isCancelled ? '(cancelled)' : ''}',
    ),
  };
}

extension RequestExtraExt on RequestOptions {
  //region 数据转换器

  /// 请求数据大小 字节数
  int get requestBytes => extra['requestBytes'] ??= 0;

  set requestBytes(int? value) => extra['requestBytes'] = value;

  /// 响应数据大小 字节数
  int get responseBytes => extra['responseBytes'] ??= 0;

  set responseBytes(int? value) => extra['responseBytes'] = value;

  //endregion

  //region 日志拦截器

  /// 打印请求/响应/错误日志
  bool get isLoggable => extra['isLog'] != false;

  /// 打印请求/响应数据日志
  bool get isLoggableData => extra['isLogData'] != false;

  /// 已获取响应
  bool get hasResponse => requestTime != null && responseTime != null;

  /// 请求到响应消耗时间
  Duration? get elapsedTime =>
      requestTime?.let((DateTime it) => responseTime?.difference(it));

  /// 请求时间
  DateTime? get requestTime => extra['requestTime'];

  set requestTime(DateTime? value) => extra['requestTime'] = value;

  /// 响应时间
  DateTime? get responseTime => extra['responseTime'];

  set responseTime(DateTime? value) => extra['responseTime'] = value;

  // endregion
}
