import 'dart:io';

import 'package:sjgtv/core/api/api.dart';
import 'package:sjgtv/core/log/log.dart';
import 'package:sjgtv/core/api/interceptor/retry_interceptor.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:dio/io.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'api_client_provider.g.dart';

Dio? _dio;

Dio get $dio => _dio!;

/// HTTP客户端 [apiClientProvider]
///
/// 覆盖配置:
/// ```dart
/// apiClientProvider.overrideWith(() =>
///       ApiClient(
///           intercepts: [...],
///           baseOptions: BaseOptions(...)
///       ));
/// ```
@Riverpod(keepAlive: true)
class ApiClientProvider extends _$ApiClientProvider {
  /// 客户端配置
  final BaseOptions? _baseOptions;

  /// 拦截器
  final List<Interceptor>? _interceptors;

  String? proxy;

  ApiClientProvider({
    BaseOptions? baseOptions,
    List<Interceptor>? interceptors,
    this.proxy,
  }) : _baseOptions =
           baseOptions ??
           BaseOptions(
             contentType: 'application/json; charset=utf-8',
             connectTimeout: const Duration(minutes: 1),
             sendTimeout: const Duration(minutes: 1),
             receiveTimeout: const Duration(minutes: 1),
           ),
       _interceptors = interceptors;

  @override
  Dio build() {
    // 客户端实例
    Dio dio = Dio(_baseOptions);

    // 添加拦截器
    dio.interceptors.addAll([
      ApiLogInterceptor(),
      ApiResultInterceptor(),
      RetryInterceptor(maxRetries: 3, retryInterval: 1000),
      ...?_interceptors,
    ]);

    // 为代理设置适配器, 不支持Web
    HttpClientAdapter adapter = dio.httpClientAdapter;
    if (adapter is IOHttpClientAdapter) {
      adapter.createHttpClient = _onHttpClientCreate;
    }

    // 销毁时关闭客户端, 如刷新提供者
    ref.onDispose(() {
      _dio?.close();
      _dio = null;
    });

    return _dio = dio;
  }

  /// 证书失效回调
  bool _onBadCertificateCallback(X509Certificate cert, String host, int port) {
    log.e(() => '$host:$port\n${cert.pem}');
    // 仅在调试模式下允许无效证书，生产环境严格验证
    return !kReleaseMode;
  }

  /// 配置代理
  String _onFindProxy(Uri uri) =>
      proxy?.isNotEmpty == true ? 'PROXY $proxy' : 'DIRECT';

  /// 客户端创建回调
  HttpClient _onHttpClientCreate() {
    HttpClient client = HttpClient();
    client.findProxy = _onFindProxy;
    client.badCertificateCallback = _onBadCertificateCallback;
    return client;
  }
}
