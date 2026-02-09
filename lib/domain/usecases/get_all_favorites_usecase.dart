import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/favorite.dart';
import 'package:sjgtv/domain/repositories/favorite_repository.dart';

/// 获取所有收藏 Use Case
class GetAllFavoritesUseCase {
  const GetAllFavoritesUseCase(this.repository);

  final FavoriteRepository repository;

  /// 执行获取
  Future<Result<List<Favorite>, Failure>> call() async {
    return repository.getAllFavorites();
  }
}