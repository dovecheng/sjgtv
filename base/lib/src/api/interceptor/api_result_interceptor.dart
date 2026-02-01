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

      response.data = <String, dynamic>{
        'code': response.statusCode ?? ApiResultModel.successfulCode,
        'data': response.data,
        'msg': response.statusMessage,
      };
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
        if (err.response?.data is Map<String, dynamic>)
          'data': err.response?.data,
      },
      requestOptions: err.requestOptions,
      extra: err.response?.extra,
    );

    handler.resolve(response);
  }
}
