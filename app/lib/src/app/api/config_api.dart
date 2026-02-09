import 'package:sjgtv/core/api/api.dart';
import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';

part 'config_api.g.dart';

/// 远程配置 API（单例）
///
/// 使用 base 的 [$dio]（含日志、拦截器等），
/// baseUrl 内定为 https://ktv.aini.us.kg/。
@RestApi(baseUrl: 'https://ktv.aini.us.kg/')
abstract class ConfigApi {
  ConfigApi._();

  static ConfigApi? _instance;

  /// 单例实例
  factory ConfigApi() =>
      _instance ??= _ConfigApi._($dio, baseUrl: 'https://ktv.aini.us.kg/');

  /// 配置文件格式：
  /// {
  ///  "sources": [ { "name", "url", "weight", "disabled" }, ... ],
  ///  "proxy": { "name", "enabled", "url" },
  ///  "tags": [ { "name", "color", "order" }, ... ]
  /// }
  @GET('config.json')
  Future<ApiResultModel<Map<String, dynamic>>> getConfig({
    @CancelRequest() CancelToken? cancelToken,
  });
}
