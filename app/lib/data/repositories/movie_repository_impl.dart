import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/repositories/proxy_repository.dart';
import 'package:sjgtv/domain/repositories/source_repository.dart';
import 'package:sjgtv/domain/entities/movie.dart';
import 'package:sjgtv/domain/repositories/movie_repository.dart';
import 'package:sjgtv/src/movie/model/movie_model.dart';

/// 电影仓库实现
///
/// 实现 MovieRepository 接口，提供电影数据的访问功能
class MovieRepositoryImpl implements MovieRepository {
  MovieRepositoryImpl({
    required this.sourceRepository,
    required this.proxyRepository,
    Dio? dio,
  }) : _dio = dio ?? Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 15),
          receiveTimeout: const Duration(seconds: 15),
        ));

  final SourceRepository sourceRepository;
  final ProxyRepository proxyRepository;
  final Dio _dio;

  @override
  Future<Result<List<Movie>, Failure>> searchMovies(
    String keyword, {
    int? limit,
  }) async {
    try {
      // 获取可用的源
      final sourcesResult = await sourceRepository.getAllSources();
      if (sourcesResult.isFailure) {
        return Result.failure(sourcesResult.error!);
      }

      final sources = sourcesResult.value!;
      final activeSources = sources.where((s) => !s.disabled).toList();

      if (activeSources.isEmpty) {
        return Result.success([]);
      }

      // 获取代理
      final proxiesResult = await proxyRepository.getEnabledProxies();
      if (proxiesResult.isFailure) {
        return Result.failure(proxiesResult.error!);
      }

      final proxies = proxiesResult.value!;
      final activeProxy = proxies.isEmpty ? null : proxies.first;

      // 执行搜索
      final results = await _executeSearch(activeSources, activeProxy, keyword);

      // 合并结果
      final merged = _mergeResults(results, activeSources);

      // 限制结果数量
      final limited = limit != null ? merged.take(limit).toList() : merged;

      return Result.success(limited);
    } catch (e) {
      return Result.failure(NetworkFailure('搜索电影失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<Movie>, Failure>> getMoviesByCategory(
    String categoryId, {
    int page = 1,
    int pageSize = 20,
  }) async {
    try {
      final sourcesResult = await sourceRepository.getAllSources();
      if (sourcesResult.isFailure) {
        return Result.failure(sourcesResult.error!);
      }

      final sources = sourcesResult.value!;
      final activeSources = sources.where((s) => !s.disabled).toList();

      if (activeSources.isEmpty) {
        return Result.success([]);
      }

      final proxiesResult = await proxyRepository.getEnabledProxies();
      if (proxiesResult.isFailure) {
        return Result.failure(proxiesResult.error!);
      }

      final proxies = proxiesResult.value!;
      final activeProxy = proxies.isEmpty ? null : proxies.first;

      final results = await _executeCategoryQuery(activeSources, activeProxy, categoryId, page: page, pageSize: pageSize);
      final merged = _mergeResults(results, activeSources);

      return Result.success(merged);
    } catch (e) {
      return Result.failure(NetworkFailure('获取分类电影失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Movie, Failure>> getMovieDetail(String movieId) async {
    try {
      final sourcesResult = await sourceRepository.getAllSources();
      if (sourcesResult.isFailure) {
        return Result.failure(sourcesResult.error!);
      }

      final sources = sourcesResult.value!;
      final activeSources = sources.where((s) => !s.disabled).toList();

      if (activeSources.isEmpty) {
        return Result.failure(const NotFoundFailure('没有可用的视频源'));
      }

      final proxiesResult = await proxyRepository.getEnabledProxies();
      if (proxiesResult.isFailure) {
        return Result.failure(proxiesResult.error!);
      }

      final proxies = proxiesResult.value!;
      final activeProxy = proxies.isEmpty ? null : proxies.first;

      final movie = await _executeDetailQuery(activeSources, activeProxy, movieId);
      if (movie != null) {
        return Result.success(movie);
      }

      return Result.failure(const NotFoundFailure('电影详情未找到'));
    } catch (e) {
      return Result.failure(NetworkFailure('获取电影详情失败: ${e.toString()}'));
    }
  }

  /// 执行搜索请求
  Future<List<dynamic>> _executeSearch(
    List<dynamic> sources,
    dynamic proxy,
    String keyword,
  ) async {
    final results = await Future.wait<dynamic>(
      sources.map((source) async {
        final baseUrl = _resolveSourceBaseUrl(proxy, source.url);
        try {
          final response = await _dio.get<dynamic>(
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
  }

  /// 合并搜索结果
  List<Movie> _mergeResults(
    List<dynamic> results,
    List<dynamic> sources,
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

        groups.putIfAbsent(key, () => []).add(entry);
      }
    }

    final merged = <Movie>[];

    for (final list in groups.values) {
      final validSources = list.where((e) {
        final play = (e['vod_play_url']?.toString() ?? '').trim();
        return play.isNotEmpty && _hasEpisodes(play);
      }).toList();

      if (validSources.isEmpty) continue;

      final main = validSources.first;
      final movie = _parseToMovie(main);
      if (movie != null) {
        merged.add(movie);
      }
    }

    merged.sort((a, b) {
      // 简单的排序逻辑
      return a.title.compareTo(b.title);
    });

    return merged;
  }

  /// 解析为 Movie 实体
  Movie? _parseToMovie(Map<String, dynamic> data) {
    try {
      return MovieModel(
        id: data['vod_id']?.toString() ?? DateTime.now().millisecondsSinceEpoch.toString(),
        title: data['vod_name']?.toString() ?? '',
        year: int.tryParse(data['vod_year']?.toString() ?? '') ?? DateTime.now().year,
        rating: double.tryParse(data['vod_score']?.toString() ?? '0') ?? 0.0,
        coverUrl: data['vod_pic']?.toString() ?? '',
        playable: true,
        isNew: false,
        url: data['vod_play_url']?.toString() ?? '',
      ).toEntity();
    } catch (e) {
      return null;
    }
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
      return jsonDecode(jsonString);
    } catch (e) {
      return null;
    }
  }

  /// 解析源基础 URL
  String _resolveSourceBaseUrl(dynamic proxy, String sourceUrl) {
    // 简化实现，直接返回源 URL
    return sourceUrl;
  }

  /// 执行分类查询请求
  Future<List<dynamic>> _executeCategoryQuery(
    List<dynamic> sources,
    dynamic proxy,
    String categoryId, {
    required int page,
    required int pageSize,
  }) async {
    final results = await Future.wait<dynamic>(
      sources.map((source) async {
        final baseUrl = _resolveSourceBaseUrl(proxy, source.url);
        try {
          final response = await _dio.get<dynamic>(
            baseUrl,
            queryParameters: {
              'ac': 'list',
              't': categoryId,
              'pg': page,
              'pagesize': pageSize,
            },
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
  }

  /// 执行详情查询请求
  Future<Movie?> _executeDetailQuery(
    List<dynamic> sources,
    dynamic proxy,
    String movieId,
  ) async {
    for (final source in sources) {
      final baseUrl = _resolveSourceBaseUrl(proxy, source.url);
      try {
        final response = await _dio.get<dynamic>(
          baseUrl,
          queryParameters: {
            'ac': 'detail',
            'ids': movieId,
          },
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
          if (decoded != null &&
              (decoded['code'] == 1 || decoded['code'] == '1') &&
              decoded['list'] != null &&
              (decoded['list'] as List<dynamic>).isNotEmpty) {
            final movieData = decoded['list'][0];
            return _parseToMovie(movieData);
          }
        }
      } catch (e) {
        continue;
      }
    }
    return null;
  }
}