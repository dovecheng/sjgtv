import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/favorite.dart';

/// 收藏仓库接口
///
/// 定义收藏数据的访问方法
abstract class FavoriteRepository {
  /// 获取所有收藏
  Future<Result<List<Favorite>, Failure>> getAllFavorites();

  /// 添加收藏
  ///
  /// [favorite] 收藏实体
  Future<Result<Favorite, Failure>> addFavorite(Favorite favorite);

  /// 删除收藏
  ///
  /// [uuid] 收藏 UUID
  Future<Result<void, Failure>> deleteFavorite(String uuid);

  /// 检查是否已收藏
  ///
  /// [movieId] 电影ID
  Future<Result<bool, Failure>> isFavorite(String movieId);

  /// 取消收藏（通过电影ID）
  ///
  /// [movieId] 电影ID
  Future<Result<void, Failure>> unfavorite(String movieId);
}
