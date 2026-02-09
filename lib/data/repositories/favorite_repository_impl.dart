import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/favorite.dart';
import 'package:sjgtv/domain/repositories/favorite_repository.dart';
import 'package:sjgtv/data/datasources/local_datasource.dart';

/// 收藏仓库实现
///
/// 实现 FavoriteRepository 接口
class FavoriteRepositoryImpl implements FavoriteRepository {
  FavoriteRepositoryImpl({
    required this.localDataSource,
  });

  final LocalDataSource localDataSource;

  @override
  Future<Result<List<Favorite>, Failure>> getAllFavorites() async {
    return localDataSource.getAllFavorites();
  }

  @override
  Future<Result<Favorite, Failure>> addFavorite(Favorite favorite) async {
    return localDataSource.addFavorite(favorite);
  }

  @override
  Future<Result<void, Failure>> deleteFavorite(String uuid) async {
    return localDataSource.deleteFavorite(uuid);
  }

  @override
  Future<Result<bool, Failure>> isFavorite(String movieId) async {
    return localDataSource.isFavorite(movieId);
  }

  @override
  Future<Result<void, Failure>> unfavorite(String movieId) async {
    return localDataSource.unfavorite(movieId);
  }
}