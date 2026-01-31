import 'package:base/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sjgtv/src/api/service/api_service.dart';

/// ApiService 提供者
///
/// 使用 base 的 [apiClientProvider]（Dio）创建 [ApiService]，供页面通过 ref 获取。
final Provider<ApiService> apiServiceProvider = Provider<ApiService>((ref) {
  final Dio dio = ref.watch(apiClientProvider);
  return ApiService(dio: dio, baseUrl: 'http://localhost:8023');
});
