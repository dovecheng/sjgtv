import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/movie.dart';
import 'package:sjgtv/domain/repositories/movie_repository.dart';

/// 获取分类电影参数
class GetMoviesByCategoryParams {
  const GetMoviesByCategoryParams({
    required this.categoryId,
    this.page = 1,
    this.pageSize = 20,
  });

  final String categoryId;
  final int page;
  final int pageSize;
}

/// 获取分类电影 Use Case
///
/// 领域层的业务逻辑，通过仓库接口获取分类下的电影
class GetMoviesByCategoryUseCase {
  const GetMoviesByCategoryUseCase(this.repository);

  final MovieRepository repository;

  /// 执行获取
  ///
  /// [params] 参数
  Future<Result<List<Movie>, Failure>> call(GetMoviesByCategoryParams params) async {
    return repository.getMoviesByCategory(
      params.categoryId,
      page: params.page,
      pageSize: params.pageSize,
    );
  }
}