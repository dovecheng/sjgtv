import 'package:sjgtv/core/log/log.dart';
import 'package:sjgtv/di/domain_di.dart';
import 'package:sjgtv/domain/usecases/usecases.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final Log _log = Log('MovieSearch');

/// 电影搜索提供者
///
/// 使用 Domain 层的 SearchMoviesUseCase 聚合各数据源 API 搜索结果。
final movieSearchProvider = Provider<MovieSearchService>((Ref ref) {
  return MovieSearchService(
    SearchMoviesUseCase(ref.read(movieRepositoryProvider)),
  );
});

class MovieSearchService {
  MovieSearchService(this._searchUseCase);

  final SearchMoviesUseCase _searchUseCase;

  /// 搜索电影，返回 { total, list }
  Future<Map<String, dynamic>> search(String keyword, {int? limit}) async {
    _log.d(() => '开始搜索: keyword="$keyword"');

    final result = await _searchUseCase(
      SearchMoviesParams(keyword: keyword, limit: limit),
    );

    return result.fold(
      (failure) {
        _log.e(() => '搜索失败: ${failure.message}');
        return {'list': <dynamic>[], 'total': 0};
      },
      (movies) {
        _log.d(() => '搜索成功: 总数=${movies.length}');
        return {
          'total': movies.length,
          'list': movies,
        };
      },
    );
  }
}
