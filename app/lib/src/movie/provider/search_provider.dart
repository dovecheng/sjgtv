import '../../../core/log/log.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sjgtv/src/movie/usecase/movie_usecase_factory.dart';
import 'package:sjgtv/src/movie/usecase/search_movies_usecase.dart';

final Log _log = Log('MovieSearch');

/// 电影搜索提供者
///
/// 使用 SearchMoviesUseCase 聚合各数据源 API 搜索结果。
final movieSearchProvider = Provider<MovieSearchService>((Ref ref) {
  return MovieSearchService(
    MovieUseCaseFactory.createSearchMoviesUseCase(ref),
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
        return {'list': <dynamic>[]};
      },
      (success) {
        _log.d(() => '搜索成功: 总数=${success.total}');
        return {
          'total': success.total,
          'list': success.movies,
        };
      },
    );
  }
}
