import 'package:base/api.dart';
import 'package:dio/dio.dart';
import 'package:sjgtv/src/api/client/api_client.dart';
import 'package:sjgtv/src/model/proxy.dart';
import 'package:sjgtv/src/model/source.dart';
import 'package:sjgtv/src/model/tag.dart';

/// API 服务层，封装 Retrofit ApiClient
///
/// 注意：fromJson 注册由 [JsonAdapterImpl] 在 AppRunner 启动时完成，
/// 拦截器由 [ApiClientProvider] 在 AppRunner 中配置。
class ApiService {
  final ApiClient _client;

  ApiService({
    required Dio dio,
    String baseUrl = 'http://localhost:8023',
  }) : _client = ApiClient(dio, baseUrl: baseUrl);

  /// 使用默认 Dio 配置创建 ApiService（用于测试或独立使用）
  factory ApiService.standalone({String baseUrl = 'http://localhost:8023'}) {
    final Dio dio = Dio(BaseOptions(
      baseUrl: baseUrl,
      connectTimeout: const Duration(seconds: 10),
      receiveTimeout: const Duration(seconds: 10),
    ));
    dio.interceptors.add(ApiResultInterceptor());
    return ApiService(dio: dio, baseUrl: baseUrl);
  }

  // --- Sources ---

  /// 获取所有数据源
  Future<ApiListResultModel<Source>> getSources() async {
    return await _client.getSources();
  }

  /// 添加数据源
  Future<ApiResultModel<Source>> addSource(Map<String, dynamic> body) async {
    return await _client.addSource(body);
  }

  /// 切换数据源启用/禁用状态
  Future<ApiResultModel<Source>> toggleSource(String id) async {
    return await _client.toggleSource(id);
  }

  /// 删除数据源
  Future<ApiResultModel<Object>> deleteSource(String id) async {
    return await _client.deleteSource(id);
  }

  // --- Proxies ---

  /// 获取所有代理
  Future<ApiListResultModel<Proxy>> getProxies() async {
    return await _client.getProxies();
  }

  /// 添加代理
  Future<ApiResultModel<Proxy>> addProxy(Map<String, dynamic> body) async {
    return await _client.addProxy(body);
  }

  /// 切换代理启用/禁用状态
  Future<ApiResultModel<Proxy>> toggleProxy(String id) async {
    return await _client.toggleProxy(id);
  }

  /// 删除代理
  Future<ApiResultModel<Object>> deleteProxy(String id) async {
    return await _client.deleteProxy(id);
  }

  // --- Tags ---

  /// 获取所有标签
  Future<ApiListResultModel<Tag>> getTags() async {
    return await _client.getTags();
  }

  /// 添加标签
  Future<ApiResultModel<Tag>> addTag(Map<String, dynamic> body) async {
    return await _client.addTag(body);
  }

  /// 更新标签
  Future<ApiResultModel<Tag>> updateTag(Map<String, dynamic> body) async {
    return await _client.updateTag(body);
  }

  /// 更新标签顺序
  Future<ApiResultModel<Object>> updateTagOrder(List<String> tagIds) async {
    return await _client.updateTagOrder({'tagIds': tagIds});
  }

  /// 删除标签
  Future<ApiResultModel<Object>> deleteTag(String id) async {
    return await _client.deleteTag(id);
  }

  // --- Search ---

  /// 搜索内容
  Future<ApiResultModel<Map<String, dynamic>>> search(
    String keyword, {
    int? limit,
  }) async {
    return await _client.search(keyword, limit: limit);
  }
}
