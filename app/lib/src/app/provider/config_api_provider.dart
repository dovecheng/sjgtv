import 'package:base/api.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sjgtv/src/app/api/config_api.dart';

part 'config_api_provider.g.dart';

/// 远程配置 API 请求结果提供者
///
/// build 为调用 [ConfigApi].getConfig() 的返回结果（Map）。
@Riverpod(keepAlive: true)
class ConfigApiProvider extends _$ConfigApiProvider {
  @override
  Future<Map<String, dynamic>?> build() async {
    final ApiResultModel<Map<String, dynamic>> result =
        await ConfigApi().getConfig();
    return result.isSuccess ? result.data : null;
  }
}
