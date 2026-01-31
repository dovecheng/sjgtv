import 'package:base/api.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sjgtv/src/proxy/proxy_model.dart';
import 'package:sjgtv/src/source/source_model.dart';
import 'package:sjgtv/src/tag/tag_model.dart';

part 'api_client.g.dart';

/// 本地 shelf 服务的 Retrofit 声明（baseUrl: http://localhost:8023）
///
/// 所有接口返回 ApiResultModel/ApiListResultModel，统一格式 { code, data, msg }
@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  // --- Sources ---
  @GET('/api/sources')
  Future<ApiListResultModel<SourceModel>> getSources();

  @POST('/api/sources')
  Future<ApiResultModel<SourceModel>> addSource(@Body() Map<String, dynamic> body);

  @PUT('/api/sources')
  Future<ApiResultModel<SourceModel>> updateSource(@Body() Map<String, dynamic> body);

  @PUT('/api/sources/toggle')
  Future<ApiResultModel<SourceModel>> toggleSource(@Query('id') String id);

  @DELETE('/api/sources')
  Future<ApiResultModel<Object>> deleteSource(@Query('id') String id);

  // --- Proxies ---
  @GET('/api/proxies')
  Future<ApiListResultModel<ProxyModel>> getProxies();

  @POST('/api/proxies')
  Future<ApiResultModel<ProxyModel>> addProxy(@Body() Map<String, dynamic> body);

  @PUT('/api/proxies/toggle')
  Future<ApiResultModel<ProxyModel>> toggleProxy(@Query('id') String id);

  @DELETE('/api/proxies')
  Future<ApiResultModel<Object>> deleteProxy(@Query('id') String id);

  // --- Tags ---
  @GET('/api/tags')
  Future<ApiListResultModel<TagModel>> getTags();

  @POST('/api/tags')
  Future<ApiResultModel<TagModel>> addTag(@Body() Map<String, dynamic> body);

  @PUT('/api/tags')
  Future<ApiResultModel<TagModel>> updateTag(@Body() Map<String, dynamic> body);

  @PUT('/api/tags/order')
  Future<ApiResultModel<Object>> updateTagOrder(@Body() Map<String, dynamic> body);

  @DELETE('/api/tags')
  Future<ApiResultModel<Object>> deleteTag(@Query('id') String id);

  // --- Search ---
  /// 搜索返回动态结构 { total, list }
  @GET('/api/search')
  Future<ApiResultModel<Map<String, dynamic>>> search(
    @Query('wd') String wd, {
    @Query('limit') int? limit,
  });
}
