import 'package:base/api.dart';
import 'package:dio/dio.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sjgtv/src/api/service/api_service.dart';

part 'api_service_provider.g.dart';

/// ApiService 提供者
///
/// 使用 base 的 [apiClientProvider]（Dio）创建 [ApiService]，供页面通过 ref 获取。
@Riverpod(keepAlive: true)
class ApiServiceProvider extends _$ApiServiceProvider {
  @override
  ApiService build() {
    final Dio dio = ref.read(apiClientProvider);
    return ApiService(dio: dio, baseUrl: 'http://localhost:8023');
  }
}
