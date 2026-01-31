import 'dart:convert';

import 'package:base/log.dart';
import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sjgtv/src/proxy/model/proxy_model.dart';
import 'package:sjgtv/src/proxy/provider/proxies_provider.dart';
import 'package:sjgtv/src/source/model/source_model.dart';
import 'package:sjgtv/src/source/provider/sources_storage_provider.dart';

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
    final List<SourceModel> sources =
        await _ref.read(sourcesStorageProvider.future);
    final List<SourceModel> activeSources =
        sources.where((SourceModel s) => !s.disabled).toList();

    if (activeSources.isEmpty) {
      return {'list': <dynamic>[]};
    }

    final List<ProxyModel> proxies =
        await _ref.read(proxiesStorageProvider.future);
    final List<ProxyModel> enabled =
        proxies.where((ProxyModel p) => p.enabled).toList();
    final ProxyModel? activeProxy =
        enabled.isEmpty ? null : enabled.first;

    final Dio dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 5);
    dio.options.receiveTimeout = const Duration(seconds: 5);
    try {
      final List<dynamic> results = await Future.wait<dynamic>(
        activeSources.map((SourceModel source) async {
          final String baseUrl = activeProxy != null
              ? '${activeProxy.url}/${source.url}'
              : source.url;
          try {
            final Response<dynamic> response = await dio.get<dynamic>(
              baseUrl,
              queryParameters: {'ac': 'videolist', 'wd': keyword},
              options: Options(
                headers: {
                  'User-Agent':
                      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
                },
              ),
            );
            if (response.statusCode == 200) {
              final dynamic data = response.data;
              if (data is String) return jsonDecode(data);
              return data;
            }
            return null;
          } catch (e, s) {
            _log.w(() => '请求源 ${source.url} 失败: $e', e, s);
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

      if (validResults.isEmpty) {
        return {'list': <dynamic>[]};
      }

      final List<dynamic> merged = _mergeResults(validResults, activeSources);
      final List<dynamic> limited =
          limit != null ? merged.take(limit).toList() : merged;

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
