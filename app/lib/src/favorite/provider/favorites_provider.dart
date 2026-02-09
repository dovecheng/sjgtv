import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sjgtv/domain/entities/favorite.dart';
import 'package:uuid/uuid.dart';
import 'package:sjgtv/di/domain_di.dart';

part 'favorites_provider.g.dart';

/// 收藏列表提供者
@Riverpod(keepAlive: true)
class FavoritesProvider extends _$FavoritesProvider {
  final _uuid = const Uuid();

  @override
  Future<List<dynamic>> build() async {
    final result = await ref.read(getAllFavoritesUseCaseProvider).call();
    return result.fold(
      (failure) => [],
      (favorites) => favorites,
    );
  }

  /// 添加收藏
  Future<void> addFavorite(Map<String, dynamic> movie) async {
    final favorite = Favorite(
      uuid: _uuid.v4(),
      movieId: movie['vod_id']?.toString() ?? '',
      movieTitle: movie['vod_name']?.toString() ?? '',
      movieCoverUrl: movie['vod_pic']?.toString() ?? '',
      movieYear: int.tryParse(movie['vod_year']?.toString() ?? '') ?? DateTime.now().year,
      movieRating: double.tryParse(movie['vod_score']?.toString() ?? '0') ?? 0.0,
      sourceName: (movie['source']?.toString() ?? movie['vod_name']?.toString() ?? '默认'),
      createdAt: DateTime.now(),
    );

    await ref.read(addFavoriteUseCaseProvider).call(favorite);
    ref.invalidateSelf();
  }

  /// 删除收藏
  Future<void> deleteFavorite(String uuid) async {
    await ref.read(deleteFavoriteUseCaseProvider).call(uuid);
    ref.invalidateSelf();
  }

  /// 检查是否已收藏
  Future<bool> isFavorite(String movieId) async {
    final result = await ref.read(isFavoriteUseCaseProvider).call(movieId);
    return result.fold(
      (failure) => false,
      (isFav) => isFav,
    );
  }

  /// 切换收藏状态
  Future<void> toggleFavorite(Map<String, dynamic> movie) async {
    final movieId = movie['vod_id']?.toString() ?? '';
    final isFav = await isFavorite(movieId);

    if (isFav) {
      await unfavorite(movieId);
    } else {
      await addFavorite(movie);
    }
  }

  /// 取消收藏（通过电影ID）
  Future<void> unfavorite(String movieId) async {
    await ref.read(unfavoriteUseCaseProvider).call(movieId);
    ref.invalidateSelf();
  }

  /// 清空所有收藏
  Future<void> clearAll() async {
    final result = await ref.read(getAllFavoritesUseCaseProvider).call();
    result.fold(
      (failure) {},
      (favorites) async {
        for (final favorite in favorites) {
          await ref.read(deleteFavoriteUseCaseProvider).call(favorite.uuid);
        }
      },
    );
    ref.invalidateSelf();
  }
}