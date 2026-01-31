import 'package:base/api.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sjgtv/src/api/service/api_service.dart';

/// ApiService 提供者
///
/// 使用 base 的 [apiClientProvider]（Dio）创建 [ApiService]，供页面通过 ref 获取。
/// - 常驻（keepAlive）：普通 [Provider] 不自动释放，与应用生命周期一致。
/// - Dio 在应用生命周期内不变，用 [ref.read] 即可，无需 [ref.watch] 避免无意义重建。
final Provider<ApiService> apiServiceProvider = Provider<ApiService>((ref) {
  final Dio dio = ref.read(apiClientProvider);
  return ApiService(dio: dio, baseUrl: 'http://localhost:8023');
});
