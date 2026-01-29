import 'dart:async';
import 'dart:convert';

import 'package:base/api.dart';
import 'package:dio/dio.dart';

/// 接口请求结果转换拦截器
class ApiResultInterceptor extends Interceptor {
  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    if (response.requestOptions.responseType == ResponseType.json) {
      // content-type: text/plain
      if (response.data is String) {
        try {
          response.data = json.decode(response.data);
        } catch (_) {}
      }

      dynamic data = response.data;
      if (response.requestOptions.path.startsWith('/') ||
          response.requestOptions.isMock) {
        if (data is Map<String, dynamic>) {
          // 兼容接口没有返回 code 默认为成功
          data['code'] ??= ApiResultModel.successfulCode;
          // 兼容接口字段命名
          data['data'] ??= data.remove('result');
          // 兼容接口字段命名
          data['msg'] ??= data.remove('message');
          // 内部接口 传递请求ID给 ApiResult._fromJson() 中使用, 用于记录日志在哪个请求中解析失败.
          data['requestId'] = response.requestOptions.requestId;
        } else {
          handler.reject(
            DioException(
              requestOptions: response.requestOptions,
              type: DioExceptionType.unknown,
              response: response,
              error: const FormatException('Invalid data format'),
            ),
            true,
          );
        }
      } else {
        // 外部接口数据包装
        response.data = <String, dynamic>{
          'code': response.statusCode ?? ApiResultModel.successfulCode,
          'data': data,
          'msg': response.statusMessage,
          'requestId': response.requestOptions.requestId,
        };
      }
    }

    if (!handler.isCompleted) {
      handler.next(response);
    }
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    Response<dynamic> response = Response(
      data: <String, dynamic>{
        'code': err.response?.statusCode ?? ApiResultModel.erroredCode,
        'errorType': ApiErrorType.byDioError(err),
        'msg': err.response?.statusMessage,
        'requestId': err.requestOptions.requestId,
        if (err.response?.data is Map<String, dynamic>)
          'data': err.response?.data,
      },
      requestOptions: err.requestOptions,
      extra: err.response?.extra,
    );

    handler.resolve(response);
  }
}
