import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/movie.dart';
import 'package:sjgtv/domain/repositories/movie_repository.dart';

/// 搜索电影参数
class SearchMoviesParams {
  const SearchMoviesParams({
    required this.keyword,
    this.limit,
  });

  final String keyword;
  final int? limit;
}

/// 搜索电影 Use Case
///
/// 领域层的业务逻辑，通过仓库接口搜索电影
class SearchMoviesUseCase {
  const SearchMoviesUseCase(this.repository);

  final MovieRepository repository;

  /// 执行搜索
  ///
  /// [params] 搜索参数
  Future<Result<List<Movie>, Failure>> call(SearchMoviesParams params) async {
    if (params.keyword.trim().isEmpty) {
      return Result.success([]);
    }

    return repository.searchMovies(
      params.keyword,
      limit: params.limit,
    );
  }
}