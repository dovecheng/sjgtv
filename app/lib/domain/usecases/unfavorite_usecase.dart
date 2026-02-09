import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/repositories/favorite_repository.dart';

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