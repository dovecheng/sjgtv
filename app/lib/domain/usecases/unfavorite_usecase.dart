import '../../../core/arch/errors/failures.dart';
import '../../../core/arch/errors/result.dart';
import '../repositories/favorite_repository.dart';

/// 取消收藏 Use Case
class UnfavoriteUseCase {
  const UnfavoriteUseCase(this.repository);

  final FavoriteRepository repository;

  /// 执行取消收藏
  ///
  /// [movieId] 电影ID
  Future<Result<void, Failure>> call(String movieId) async {
    return repository.unfavorite(movieId);
  }
}