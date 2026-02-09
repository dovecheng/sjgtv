import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/repositories/favorite_repository.dart';

/// 检查是否已收藏 Use Case
class IsFavoriteUseCase {
  const IsFavoriteUseCase(this.repository);

  final FavoriteRepository repository;

  /// 执行检查
  ///
  /// [movieId] 电影ID
  Future<Result<bool, Failure>> call(String movieId) async {
    return repository.isFavorite(movieId);
  }
}
