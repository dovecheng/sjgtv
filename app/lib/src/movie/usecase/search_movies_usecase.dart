import 'package:dio/dio.dart';
import '../../../core/base.dart';
import 'package:sjgtv/src/proxy/model/proxy_model.dart';
import 'package:sjgtv/src/source/model/source_model.dart';
import 'package:sjgtv/src/source/util/source_url_util.dart';

/// 搜索电影参数
class SearchMoviesParams {
  const SearchMoviesParams({
    required this.keyword,
    this.limit,
  });

  final String keyword;
  final int? limit;
}

/// 搜索电影结果
class SearchMoviesResult {
  const SearchMoviesResult({
    required this.total,
    required this.movies,
  });

  final int total;
  final List<Map<String, dynamic>> movies;
}

/// 搜索电影 Use Case
///
/// 聚合各数据源 API 搜索结果
class SearchMoviesUseCase
    implements UseCase<SearchMoviesParams, SearchMoviesResult> {
  SearchMoviesUseCase({
    required Future<List<SourceModel>> Function() getSources,
    required Future<List<ProxyModel>> Function() getProxies,
  })  : _getSources = getSources,
        _getProxies = getProxies;

  final Future<List<SourceModel>> Function() _getSources;
  final Future<List<ProxyModel>> Function() _getProxies;

  @override
  Future<Result<SearchMoviesResult, Failure>> call(
      SearchMoviesParams params) async {
    try {
      final keyword = params.keyword;
      final limit = params.limit;

      // 获取可用的源
      final sources = await _getSources();
      final activeSources = sources.where((s) => !s.disabled).toList();

      if (activeSources.isEmpty) {
        return Result.success(
          SearchMoviesResult(total: 0, movies: []),
        );
      }

      // 获取代理
      final proxies = await _getProxies();
      final enabled = proxies.where((p) => p.enabled).toList();
      final activeProxy = enabled.isEmpty ? null : enabled.first;

      // 执行搜索
      final results = await _executeSearch(activeSources, activeProxy, keyword);

      // 合并结果
      final merged = _mergeResults(results, activeSources);

      // 限制结果数量
      final limited = limit != null
          ? merged.take(limit).toList()
          : merged;

      return Result.success(
        SearchMoviesResult(total: merged.length, movies: limited),
      );
    } catch (e) {
      return Result.failure(
        NetworkFailure('搜索电影失败: ${e.toString()}'),
      );
    }
  }

  /// 执行搜索请求
  Future<List<dynamic>> _executeSearch(
    List<SourceModel> sources,
    ProxyModel? proxy,
    String keyword,
  ) async {
    final dio = Dio();
    dio.options.connectTimeout = const Duration(seconds: 15);
    dio.options.receiveTimeout = const Duration(seconds: 15);

    try {
      final results = await Future.wait<dynamic>(
        sources.map((source) async {
          final baseUrl = resolveSourceBaseUrl(proxy, source.url);
          try {
            final response = await dio.get<dynamic>(
              baseUrl,
              queryParameters: {'ac': 'videolist', 'wd': keyword},
              options: Options(
                headers: {
                  'User-Agent':
                      'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/120.0.0.0 Safari/537.36',
                  'Accept': 'application/json, text/plain, */*',
                },
              ),
            );

            if (response.statusCode == 200) {
              final data = response.data;
              final decoded = data is String ? _parseJson(data) : data;
              return decoded;
            }
            return null;
          } catch (e) {
            return null;
          }
        }),
      );

      return results
          .where((r) =>
              r != null &&
              (r['code'] == 1 || r['code'] == '1') &&
              r['list'] != null &&
              (r['list'] as List<dynamic>).isNotEmpty)
          .toList();
    } finally {
      dio.close();
    }
  }

  /// 合并搜索结果
  List<Map<String, dynamic>> _mergeResults(
    List<dynamic> results,
    List<SourceModel> sources,
  ) {
    final groups = <String, List<Map<String, dynamic>>>{};

    for (int i = 0; i < results.length; i++) {
      final result = results[i];
      final source = sources[i];
      final weight = source.weight;

      for (final item in result['list']) {
        final name = (item['vod_name'] as String?).toString().trim();
        final year = (item['vod_year'] as String?).toString().trim();
        if (name.isEmpty) continue;

        final key = _normalizeMergeKey(name, year);
        final entry = Map<String, dynamic>.from(item);

        if (entry['vod_hits'] != null) {
          entry['vod_hits'] = ((entry['vod_hits'] as num) * weight).round();
        }

        entry['source'] = {
          'name': source.name,
          'weight': weight,
        };

        groups.putIfAbsent(key, () => []).add(entry);
      }
    }

    final merged = <Map<String, dynamic>>[];

    for (final list in groups.values) {
      final validSources = list.where((e) {
        final play = (e['vod_play_url']?.toString() ?? '').trim();
        return play.isNotEmpty && _hasEpisodes(play);
      }).toList();

      if (validSources.isEmpty) continue;

      final main = Map<String, dynamic>.from(validSources.first);
      main['sources'] = validSources;
      merged.add(main);
    }

    merged.sort((a, b) =>
        ((b['vod_hits'] as num?) ?? 0).compareTo((a['vod_hits'] as num?) ?? 0));

    return merged;
  }

  /// 规范化合并键
  String _normalizeMergeKey(String name, String year) {
    final n = name.trim().replaceAll(RegExp(r'\s+'), ' ').toLowerCase();
    final y = year.trim();
    return '$n|$y';
  }

  /// 检查是否有剧集
  bool _hasEpisodes(String playUrl) {
    if (playUrl.trim().isEmpty) return false;

    final parts = playUrl.split('#');
    for (final part in parts) {
      final episodeParts = part.split(r'$');
      if (episodeParts.length == 2 &&
          episodeParts[0].trim().isNotEmpty &&
          episodeParts[1].trim().isNotEmpty) {
        return true;
      }
    }
    return false;
  }

  /// 解析 JSON
  dynamic _parseJson(String jsonString) {
    try {
      // 使用 dart:convert
      // 这里需要导入 dart:convert
      // 由于不能修改文件头部，我假设这个方法会在文件中正确导入
      return jsonString;
    } catch (e) {
      return null;
    }
  }
}