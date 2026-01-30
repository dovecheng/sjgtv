import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'api_client.g.dart';

/// 本地 shelf 服务（通常 baseUrl 为 http://localhost:8023）的 Retrofit 声明。
/// 返回 JSON 解码结果；调用方用 [api.dart] 的 Source/Proxy/Tag.fromJson 转模型。
/// 创建示例：`ApiClient(dio, baseUrl: 'http://localhost:8023')`
@RestApi()
abstract class ApiClient {
  factory ApiClient(Dio dio, {String? baseUrl}) = _ApiClient;

  // --- Sources ---
  @GET('/api/sources')
  Future<List<Map<String, dynamic>>> getSources();

  @POST('/api/sources')
  Future<Map<String, dynamic>> addSource(@Body() Map<String, dynamic> body);

  @PUT('/api/sources/toggle')
  Future<Map<String, dynamic>> toggleSource(@Query('id') String id);

  @DELETE('/api/sources')
  Future<Map<String, dynamic>> deleteSource(@Query('id') String id);

  // --- Proxies ---
  @GET('/api/proxies')
  Future<List<Map<String, dynamic>>> getProxies();

  @POST('/api/proxies')
  Future<Map<String, dynamic>> addProxy(@Body() Map<String, dynamic> body);

  @PUT('/api/proxies/toggle')
  Future<Map<String, dynamic>> toggleProxy(@Query('id') String id);

  @DELETE('/api/proxies')
  Future<Map<String, dynamic>> deleteProxy(@Query('id') String id);

  // --- Tags ---
  @GET('/api/tags')
  Future<List<Map<String, dynamic>>> getTags();

  @POST('/api/tags')
  Future<Map<String, dynamic>> addTag(@Body() Map<String, dynamic> body);

  @PUT('/api/tags')
  Future<Map<String, dynamic>> updateTag(@Body() Map<String, dynamic> body);

  @PUT('/api/tags/order')
  Future<Map<String, dynamic>> updateTagOrder(
      @Body() Map<String, dynamic> body); // { "tagIds": ["id1", "id2", ...] }

  @DELETE('/api/tags')
  Future<Map<String, dynamic>> deleteTag(@Query('id') String id);

  // --- Search ---
  @GET('/api/search')
  Future<Map<String, dynamic>> search(
    @Query('wd') String wd, {
    @Query('limit') int? limit,
  });
}
