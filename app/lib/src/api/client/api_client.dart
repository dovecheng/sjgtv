import 'package:base/api.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import 'package:sjgtv/src/model/proxy.dart';
import 'package:sjgtv/src/model/source.dart';
import 'package:sjgtv/src/model/tag.dart';

part 'api_client.g.dart';

/// 本地 shelf 服务的 Retrofit 声明（baseUrl: http://localhost:8023）
///
/// 所有接口返回 ApiResultModel/ApiListResultModel，统一格式 { code, data, msg }
@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  // --- Sources ---
  @GET('/api/sources')
  Future<ApiListResultModel<Source>> getSources();

  @POST('/api/sources')
  Future<ApiResultModel<Source>> addSource(@Body() Map<String, dynamic> body);

  @PUT('/api/sources/toggle')
  Future<ApiResultModel<Source>> toggleSource(@Query('id') String id);

  @DELETE('/api/sources')
  Future<ApiResultModel<Object>> deleteSource(@Query('id') String id);

  // --- Proxies ---
  @GET('/api/proxies')
  Future<ApiListResultModel<Proxy>> getProxies();

  @POST('/api/proxies')
  Future<ApiResultModel<Proxy>> addProxy(@Body() Map<String, dynamic> body);

  @PUT('/api/proxies/toggle')
  Future<ApiResultModel<Proxy>> toggleProxy(@Query('id') String id);

  @DELETE('/api/proxies')
  Future<ApiResultModel<Object>> deleteProxy(@Query('id') String id);

  // --- Tags ---
  @GET('/api/tags')
  Future<ApiListResultModel<Tag>> getTags();

  @POST('/api/tags')
  Future<ApiResultModel<Tag>> addTag(@Body() Map<String, dynamic> body);

  @PUT('/api/tags')
  Future<ApiResultModel<Tag>> updateTag(@Body() Map<String, dynamic> body);

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
