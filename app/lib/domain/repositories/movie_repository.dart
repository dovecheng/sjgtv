import '../../../core/arch/errors/failures.dart';
import '../../../core/arch/errors/result.dart';
import '../entities/movie.dart';

/// 电影仓库接口
///
/// 定义电影数据的访问方法，不关心具体实现细节
abstract class MovieRepository {
  /// 搜索电影
  ///
  /// [keyword] 搜索关键词
  /// [limit] 返回结果数量限制
  Future<Result<List<Movie>, Failure>> searchMovies(
    String keyword, {
    int? limit,
  });

  /// 根据分类获取电影列表
  ///
  /// [categoryId] 分类 ID
  /// [page] 页码
  /// [pageSize] 每页数量
  Future<Result<List<Movie>, Failure>> getMoviesByCategory(
    String categoryId, {
    int page = 1,
    int pageSize = 20,
  });

  /// 获取电影详情
  ///
  /// [movieId] 电影 ID
  Future<Result<Movie, Failure>> getMovieDetail(String movieId);
}