import '../../../core/arch/errors/failures.dart';
import '../../../core/arch/errors/result.dart';
import '../repositories/favorite_repository.dart';

/// 删除收藏 Use Case
class DeleteFavoriteUseCase {
  const DeleteFavoriteUseCase(this.repository);

  final FavoriteRepository repository;

  /// 执行删除
  ///
  /// [uuid] 收藏 UUID
  Future<Result<void, Failure>> call(String uuid) async {
    return repository.deleteFavorite(uuid);
  }
}