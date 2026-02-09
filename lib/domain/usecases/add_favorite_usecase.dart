import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/favorite.dart';
import 'package:sjgtv/domain/repositories/favorite_repository.dart';

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
