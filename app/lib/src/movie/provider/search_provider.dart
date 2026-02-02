import 'dart:convert';

import 'package:base/log.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sjgtv/src/proxy/model/proxy_model.dart';
import 'package:sjgtv/src/proxy/provider/proxies_provider.dart';
import 'package:sjgtv/src/source/model/source_model.dart';
import 'package:sjgtv/src/source/provider/sources_provider.dart';
import 'package:sjgtv/src/source/util/source_url_util.dart';

final Log _log = Log('MovieSearch');

/// 电影搜索提供者
///
/// 聚合各数据源 API 搜索结果，与 shelf 的 _handleSearchRequest 逻辑一致。
final movieSearchProvider = Provider<MovieSearchService>((Ref ref) {
  return MovieSearchService(ref);
});

class MovieSearchService {
  MovieSearchService(this._ref);

  final Ref _ref;

  /// 搜索电影，返回 { total, list }
  Future<Map<String, dynamic>> search(String keyword, {int? limit}) async {
    _log.d(() => '开始搜索: keyword="$keyword"');

    final List<SourceModel> sources =
        await _ref.read(sourcesProvider.future);
    final List<SourceModel> activeSources =
        sources.where((SourceModel s) => !s.disabled).toList();

    _log.d(() => '源: 总数=${sources.length}, 启用=${activeSources.length}');
    for (final SourceModel s in activeSources) {
      _log.d(() => '源: name="${s.name}" url="${s.url}"');
    }

    if (activeSources.isEmpty) {
      _log.d(() => '无可用源，返回空列表');
      return {'list': <dynamic>[]};
    }

    final List<ProxyModel> proxies =
        await _ref.read(proxiesStorageProvider.future);
    final List<ProxyModel> enabled =
        proxies.where((ProxyModel p) => p.enabled).toList();
    final ProxyModel? activeProxy =
        enabled.isEmpty ? null : enabled.first;
    if (activeProxy != null) {
      _log.d(() => '使用代理: ${activeProxy.url}');
    } else {
      _log.d(() => '未使用代理');
    }

    final Dio dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);
    try {
      final List<dynamic> results = await Future.wait<dynamic>(
        activeSources.map((SourceModel source) async {
          final String baseUrl =
              resolveSourceBaseUrl(activeProxy, source.url);
          final String requestUrl =
              '$baseUrl?ac=videolist&wd=${Uri.encodeQueryComponent(keyword)}';
          _log.d(() => '请求源: ${source.name} -> $requestUrl');
          try {
            final Uri uri = Uri.parse(baseUrl);
            final String origin =
                '${uri.scheme}://${uri.host}${uri.port != 80 && uri.port != 443 ? ':${uri.port}' : ''}';
            final Response<dynamic> response = await dio.get<dynamic>(
              baseUrl,
              queryParameters: {'ac': 'videolist', 'wd': keyword},
              options: Options(
                headers: <String, String>{
                  'User-Agent':
                      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
                  'Accept': 'application/json, text/plain, */*',
                  'Referer': '$origin/',
                },
              ),
            );
            if (response.statusCode == 200) {
              final dynamic data = response.data;
              final dynamic decoded =
                  data is String ? jsonDecode(data) : data;
              final dynamic code = decoded is Map ? decoded['code'] : null;
              final int listLen = decoded is Map && decoded['list'] is List
                  ? (decoded['list'] as List<dynamic>).length
                  : 0;
              _log.d(() =>
                  '源 ${source.name} 响应: status=200 code=$code list长度=$listLen');
              return decoded;
            }
            _log.d(() =>
                '源 ${source.name} 响应: status=${response.statusCode}');
            return null;
          } catch (e, s) {
            final int? statusCode = e is DioException && e.response != null
                ? e.response!.statusCode
                : null;
            _log.e(
              () =>
                  '源 ${source.name} 请求失败${statusCode != null ? ' status=$statusCode' : ''}: $e',
              e,
              s,
            );
            return null;
          }
        }),
      );

      final List<dynamic> validResults = results
          .where(
            (dynamic r) =>
                r != null &&
                (r['code'] == 1 || r['code'] == '1') &&
                r['list'] != null &&
                (r['list'] as List<dynamic>).isNotEmpty,
          )
          .toList();

      _log.d(() =>
          '有效结果源数=${validResults.length}, 原始结果数=${results.length}');
      for (int i = 0; i < results.length; i++) {
        final dynamic r = results[i];
        if (r == null) {
          _log.d(() => '结果[$i] ${activeSources[i].name}: null');
        } else if (r is Map) {
          final dynamic code = r['code'];
          final int len =
              r['list'] is List ? (r['list'] as List<dynamic>).length : 0;
          final bool valid =
              (code == 1 || code == '1') && r['list'] != null && len > 0;
          _log.d(() =>
              '结果[$i] ${activeSources[i].name}: code=$code list长度=$len 有效=$valid');
        }
      }

      if (validResults.isEmpty) {
        _log.d(() => '无有效结果，返回空列表');
        return {'list': <dynamic>[]};
      }

      final List<dynamic> merged = _mergeResults(validResults, activeSources);
      final List<dynamic> limited =
          limit != null ? merged.take(limit).toList() : merged;

      _log.d(() => '合并后条数=${merged.length}, 限制后=${limited.length}');
      return {'total': merged.length, 'list': limited};
    } finally {
      dio.close();
    }
  }

  List<dynamic> _mergeResults(
      List<dynamic> results, List<SourceModel> sources) {
    final List<dynamic> merged = <dynamic>[];
    final Set<String> seenIds = <String>{};

    for (int i = 0; i < results.length; i++) {
      final dynamic result = results[i];
      final int weight = sources[i].weight;

      for (final dynamic item in result['list']) {
        final String vodId = item['vod_id']?.toString() ?? '';
        if (seenIds.contains(vodId)) continue;
        seenIds.add(vodId);

        final Map<String, dynamic> weighted =
            Map<String, dynamic>.from(item);
        if (weighted['vod_hits'] != null) {
          weighted['vod_hits'] =
              ((weighted['vod_hits'] as num) * weight).round();
        }
        weighted['source'] = {
          'name': sources[i].name,
          'weight': weight,
        };
        merged.add(weighted);
      }
    }

    merged.sort(
        (dynamic a, dynamic b) =>
            ((b['vod_hits'] as num?) ?? 0).compareTo((a['vod_hits'] as num?) ?? 0));
    return merged;
  }
}
