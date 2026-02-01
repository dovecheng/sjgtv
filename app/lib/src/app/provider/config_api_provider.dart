import 'package:base/api.dart';
import 'package:base/log.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
part 'config_api_provider.g.dart';

const String _configUrl = 'https://ktv.aini.us.kg/config.json';

final Log _configLog = Log('ConfigApi');

void _configPrint(String msg) {
  debugPrint('[Config] $msg');
  _configLog.d(() => msg);
}

/// 远程配置 API 请求结果提供者
///
/// build 为调用 [ConfigApi].getConfig() 的返回结果（Map）。
/// 兼容服务端返回裸 config（直接 sources/proxy/tags）或 ApiResultModel 包装格式。
@Riverpod(keepAlive: true)
class ConfigApiProvider extends _$ConfigApiProvider {
  @override
  Future<Map<String, dynamic>?> build() async {
    _configPrint('开始请求 config: $_configUrl');
    final Dio dio = ref.read(apiClientProvider);
    try {
      final Response<dynamic> response =
          await dio.get<dynamic>(_configUrl);
      final dynamic body = response.data;
      if (body is! Map<String, dynamic>) {
        _configPrint('直连 config 响应非 Map');
        return null;
      }
      Map<String, dynamic>? config;
      if (body.containsKey('data') && body['data'] is Map<String, dynamic>) {
        config = body['data'] as Map<String, dynamic>;
        _configPrint(
            '直连 config 成功(拦截器包装), sources=${config['sources']?.length}, tags=${config['tags']?.length}');
      } else if (body.containsKey('sources') || body.containsKey('tags')) {
        config = body;
        _configPrint(
            '直连 config 成功(裸格式), sources=${config['sources']?.length}, tags=${config['tags']?.length}');
      }
      if (config != null) return config;
      _configPrint('直连 config 无 sources/tags');
    } catch (e, s) {
      debugPrint('[Config] 直连 $_configUrl 失败: $e');
      _configLog.e(() => '直连 $_configUrl 失败: $e', e, s);
    }
    return null;
  }
}
