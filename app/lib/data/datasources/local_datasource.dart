import '../../../core/arch/errors/failures.dart';
import '../../../core/arch/errors/result.dart';
import '../../domain/entities/source.dart';
import '../../domain/entities/proxy.dart';
import '../../domain/entities/tag.dart';
import '../../domain/entities/watch_history.dart';
import '../../domain/entities/favorite.dart';
import '../../domain/entities/settings.dart';

/// 本地数据源接口
///
/// 定义本地数据访问方法
abstract class LocalDataSource {
  /// 获取所有视频源
  Future<Result<List<Source>, Failure>> getAllSources();

  /// 添加视频源
  Future<Result<Source, Failure>> addSource(Source source);

  /// 更新视频源
  Future<Result<Source, Failure>> updateSource(Source source);

  /// 删除视频源
  Future<Result<void, Failure>> deleteSource(String uuid);

  /// 获取所有代理
  Future<Result<List<Proxy>, Failure>> getAllProxies();

  /// 获取启用的代理
  Future<Result<List<Proxy>, Failure>> getEnabledProxies();

  /// 添加代理
  Future<Result<Proxy, Failure>> addProxy(Proxy proxy);

  /// 更新代理
  Future<Result<Proxy, Failure>> updateProxy(Proxy proxy);

  /// 删除代理
  Future<Result<void, Failure>> deleteProxy(String uuid);

  /// 获取所有标签
  Future<Result<List<Tag>, Failure>> getAllTags();

  /// 添加标签
  Future<Result<Tag, Failure>> addTag(Tag tag);

  /// 更新标签
  Future<Result<Tag, Failure>> updateTag(Tag tag);

  /// 删除标签
  Future<Result<void, Failure>> deleteTag(String uuid);

  /// 添加或更新观看历史
  Future<Result<WatchHistory, Failure>> addOrUpdateWatchHistory(
      WatchHistory history);

  /// 获取所有观看历史
  Future<Result<List<WatchHistory>, Failure>> getAllWatchHistories();

  /// 获取指定电影的观看历史
  Future<Result<List<WatchHistory>, Failure>> getWatchHistoriesByMovie(
      String movieId);

  /// 删除观看历史
  Future<Result<void, Failure>> deleteWatchHistory(String id);

  /// 清除所有观看历史
  Future<Result<void, Failure>> clearAllWatchHistories();

  /// 获取所有收藏
  Future<Result<List<Favorite>, Failure>> getAllFavorites();

  /// 添加收藏
  Future<Result<Favorite, Failure>> addFavorite(Favorite favorite);

  /// 删除收藏
  Future<Result<void, Failure>> deleteFavorite(String uuid);

  /// 检查是否已收藏
  Future<Result<bool, Failure>> isFavorite(String movieId);

  /// 取消收藏（通过电影ID）
  Future<Result<void, Failure>> unfavorite(String movieId);

  /// 获取设置
  Future<Result<Settings, Failure>> getSettings();

  /// 保存设置
  Future<Result<Settings, Failure>> saveSettings(Settings settings);

  /// 更新设置
  Future<Result<Settings, Failure>> updateSettings(Settings settings);
}