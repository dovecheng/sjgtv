import '../../../core/arch/errors/failures.dart';
import '../../../core/arch/errors/result.dart';
import '../entities/favorite.dart';
import '../repositories/favorite_repository.dart';

/// 添加收藏 Use Case
class AddFavoriteUseCase {
  const AddFavoriteUseCase(this.repository);

  final FavoriteRepository repository;

  /// 执行添加
  ///
  /// [favorite] 收藏实体
  Future<Result<Favorite, Failure>> call(Favorite favorite) async {
    return repository.addFavorite(favorite);
  }
}