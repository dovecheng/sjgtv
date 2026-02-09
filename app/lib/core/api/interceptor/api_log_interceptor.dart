import 'dart:async';

import '../../../core/api.dart';
import '../../../core/log.dart';
import 'package:dio/dio.dart';

/// 日志记录拦截器
class ApiLogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    options.setupRequestEncoder();
    options.setupResponseDecoder();
    options.requestTime = DateTime.now();

    if (options.isLoggable) {
      Future<void>.delayed(const Duration(seconds: 3)).then((_) {
        if (!options.hasResponse) {
          log.i(
            () =>
                '${options.method} ${options.path}\n${options.toMap().format()}',
          );
        }
      });
    }

    handler.next(options);
  }

  @override
  void onResponse(
    Response<dynamic> response,
    ResponseInterceptorHandler handler,
  ) {
    response.requestOptions.responseTime = DateTime.now();

    if (response.requestOptions.isLoggable) {
      LogLevel level = response.statusCode == 200
          ? LogLevel.info
          : LogLevel.warn;

      log.log(level, () {
        Map<String, dynamic> map = {
          ...response.requestOptions.toMap(),
          ...response.toMap(),
        };
        return '${response.requestOptions.method} '
            '${response.requestOptions.path}\n'
            '${map.format()}';
      });
    }

    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    err.requestOptions.responseTime ??= DateTime.now();

    if (err.requestOptions.isLoggable) {
      log.e(() {
        Map<String, dynamic> map = {
          ...err.requestOptions.toMap(),
          ...?err.response?.toMap(),
        };
        return '${err.requestOptions.method} '
            '${err.requestOptions.path}\n'
            '${map.format()}\n';
      }, err);
    }

    handler.next(err);
  }
}
