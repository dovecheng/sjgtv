
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:isar_community/isar.dart';
import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/source.dart';
import 'package:sjgtv/domain/entities/proxy.dart';
import 'package:sjgtv/domain/entities/tag.dart';
import 'package:sjgtv/domain/entities/watch_history.dart';
import 'package:sjgtv/domain/entities/favorite.dart';
import 'package:sjgtv/domain/entities/settings.dart';
import 'package:sjgtv/data/datasources/local_datasource.dart';
import 'package:sjgtv/core/isar/isar.dart';
import 'package:sjgtv/src/source/model/source_model.dart';
import 'package:sjgtv/src/proxy/model/proxy_model.dart';
import 'package:sjgtv/src/tag/model/tag_model.dart';
import 'package:sjgtv/src/watch_history/model/watch_history_model.dart';
import 'package:sjgtv/src/favorite/model/favorite_model.dart';
import 'package:sjgtv/src/settings/model/settings_model.dart';

part 'local_datasource_impl.g.dart';

/// 本地数据源实现
///
/// 使用 Isar 数据库实现本地数据访问
@Riverpod(keepAlive: true)
class LocalDataSourceImpl extends _$LocalDataSourceImpl
    implements LocalDataSource {
  @override
  LocalDataSourceImpl build() => LocalDataSourceImpl();

  LocalDataSourceImpl() : _uuid = const Uuid();

  final Uuid _uuid;

  @override
  Future<Result<List<Source>, Failure>> getAllSources() async {
    try {
      final List<SourceModel> list = await $isar.sources
          .where()
          .sortByUpdatedAtDesc()
          .findAll();
      return Result.success(list.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Result.failure(CacheFailure('获取视频源失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Source, Failure>> addSource(Source source) async {
    try {
      final now = DateTime.now();
      final model = SourceModel(
        uuid: source.uuid.isEmpty ? _uuid.v4() : source.uuid,
        name: source.name,
        url: source.url,
        weight: source.weight,
        disabled: source.disabled,
        tagIds: source.tagIds,
        createdAt: source.createdAt ?? now,
        updatedAt: now,
      );

      await $isar.writeTxn(() async => $isar.sources.put(model));
      return Result.success(model.toEntity());
    } catch (e) {
      return Result.failure(CacheFailure('添加视频源失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Source, Failure>> updateSource(Source source) async {
    try {
      final now = DateTime.now();
      final model = SourceModel(
        uuid: source.uuid,
        name: source.name,
        url: source.url,
        weight: source.weight,
        disabled: source.disabled,
        tagIds: source.tagIds,
        createdAt: source.createdAt,
        updatedAt: now,
      );

      await $isar.writeTxn(() async => $isar.sources.put(model));
      return Result.success(model.toEntity());
    } catch (e) {
      return Result.failure(CacheFailure('更新视频源失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> deleteSource(String uuid) async {
    try {
      await $isar.writeTxn(() async {
        final List<SourceModel> list = await $isar.sources
            .where()
            .filter()
            .uuidEqualTo(uuid)
            .findAll();
        for (final SourceModel e in list) {
          if (e.id != null) await $isar.sources.delete(e.id!);
        }
      });
      return Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure('删除视频源失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<Proxy>, Failure>> getAllProxies() async {
    try {
      final List<ProxyModel> list = await $isar.proxies
          .where()
          .sortByUpdatedAtDesc()
          .findAll();
      return Result.success(list.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Result.failure(CacheFailure('获取代理失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<Proxy>, Failure>> getEnabledProxies() async {
    try {
      final List<ProxyModel> list = await $isar.proxies
          .where()
          .filter()
          .enabledEqualTo(true)
          .sortByUpdatedAtDesc()
          .findAll();
      return Result.success(list.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Result.failure(CacheFailure('获取代理失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Proxy, Failure>> addProxy(Proxy proxy) async {
    try {
      final now = DateTime.now();
      final model = ProxyModel(
        uuid: proxy.uuid.isEmpty ? _uuid.v4() : proxy.uuid,
        url: proxy.url,
        name: proxy.name,
        enabled: proxy.enabled,
        createdAt: proxy.createdAt ?? now,
        updatedAt: now,
      );

      await $isar.writeTxn(() async => $isar.proxies.put(model));
      return Result.success(model.toEntity());
    } catch (e) {
      return Result.failure(CacheFailure('添加代理失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Proxy, Failure>> updateProxy(Proxy proxy) async {
    try {
      final now = DateTime.now();
      final model = ProxyModel(
        uuid: proxy.uuid,
        url: proxy.url,
        name: proxy.name,
        enabled: proxy.enabled,
        createdAt: proxy.createdAt,
        updatedAt: now,
      );

      await $isar.writeTxn(() async => $isar.proxies.put(model));
      return Result.success(model.toEntity());
    } catch (e) {
      return Result.failure(CacheFailure('更新代理失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> deleteProxy(String uuid) async {
    try {
      await $isar.writeTxn(() async {
        final List<ProxyModel> list = await $isar.proxies
            .where()
            .filter()
            .uuidEqualTo(uuid)
            .findAll();
        for (final ProxyModel e in list) {
          if (e.id != null) await $isar.proxies.delete(e.id!);
        }
      });
      return Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure('删除代理失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<Tag>, Failure>> getAllTags() async {
    try {
      final List<TagModel> list = await $isar.tags
          .where()
          .sortByOrder()
          .findAll();
      return Result.success(list.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Result.failure(CacheFailure('获取标签失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Tag, Failure>> addTag(Tag tag) async {
    try {
      final now = DateTime.now();
      final model = TagModel(
        uuid: tag.uuid.isEmpty ? _uuid.v4() : tag.uuid,
        name: tag.name,
        color: tag.color,
        order: tag.order,
        createdAt: tag.createdAt ?? now,
        updatedAt: now,
      );

      await $isar.writeTxn(() async => $isar.tags.put(model));
      return Result.success(model.toEntity());
    } catch (e) {
      return Result.failure(CacheFailure('添加标签失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Tag, Failure>> updateTag(Tag tag) async {
    try {
      final now = DateTime.now();
      final model = TagModel(
        uuid: tag.uuid,
        name: tag.name,
        color: tag.color,
        order: tag.order,
        createdAt: tag.createdAt,
        updatedAt: now,
      );

      await $isar.writeTxn(() async => $isar.tags.put(model));
      return Result.success(model.toEntity());
    } catch (e) {
      return Result.failure(CacheFailure('更新标签失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> deleteTag(String uuid) async {
    try {
      await $isar.writeTxn(() async {
        final List<TagModel> toDelete = await $isar.tags
            .where()
            .filter()
            .uuidEqualTo(uuid)
            .findAll();
        for (final TagModel t in toDelete) {
          if (t.id != null) await $isar.tags.delete(t.id!);
        }
        final List<SourceModel> sources = await $isar.sources.where().findAll();
        for (final SourceModel s in sources) {
          if (s.tagIds.contains(uuid)) {
            s.tagIds.remove(uuid);
            s.updatedAt = DateTime.now();
            await $isar.sources.put(s);
          }
        }
      });
      return Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure('删除标签失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<WatchHistory, Failure>> addOrUpdateWatchHistory(
      WatchHistory history) async {
    try {
      final model = WatchHistoryModel.fromEntity(history);
      await $isar.writeTxn(() async => $isar.watchHistories.put(model));
      return Result.success(history);
    } catch (e) {
      return Result.failure(CacheFailure('添加观看历史失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<WatchHistory>, Failure>> getAllWatchHistories() async {
    try {
      final List<WatchHistoryModel> list = await $isar.watchHistories
          .where()
          .sortByWatchedAtDesc()
          .findAll();
      return Result.success(list.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Result.failure(CacheFailure('获取观看历史失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<WatchHistory>, Failure>> getWatchHistoriesByMovie(
      String movieId) async {
    try {
      final List<WatchHistoryModel> list = await $isar.watchHistories
          .where()
          .filter()
          .movieIdEqualTo(movieId)
          .sortByWatchedAtDesc()
          .findAll();
      return Result.success(list.map((m) => m.toEntity()).toList());
    } catch (e) {
      return Result.failure(CacheFailure('获取观看历史失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> deleteWatchHistory(String id) async {
    try {
      await $isar.writeTxn(() async {
        final List<WatchHistoryModel> list = await $isar.watchHistories
            .where()
            .filter()
            .uuidEqualTo(id)
            .findAll();
        for (final WatchHistoryModel e in list) {
          if (e.id != null) await $isar.watchHistories.delete(e.id!);
        }
      });
      return Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure('删除观看历史失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> clearAllWatchHistories() async {
    try {
      await $isar.writeTxn(() async => $isar.watchHistories.clear());
      return Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure('清除观看历史失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<Favorite>, Failure>> getAllFavorites() async {
    try {
      final List<FavoriteModel> models = await $isar.favorites
          .where()
          .sortByCreatedAtDesc()
          .findAll();
      final List<Favorite> favorites = models.map((m) => m.toEntity()).toList();
      return Result.success(favorites);
    } catch (e) {
      return Result.failure(CacheFailure('获取收藏失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Favorite, Failure>> addFavorite(Favorite favorite) async {
    try {
      final now = DateTime.now();
      final model = FavoriteModel(
        uuid: favorite.uuid.isEmpty ? _uuid.v4() : favorite.uuid,
        movieId: favorite.movieId,
        movieTitle: favorite.movieTitle,
        movieCoverUrl: favorite.movieCoverUrl,
        movieYear: favorite.movieYear,
        movieRating: favorite.movieRating,
        sourceName: favorite.sourceName,
        createdAt: favorite.createdAt ?? now,
      );
      await $isar.writeTxn(() async => $isar.favorites.put(model));
      return Result.success(model.toEntity());
    } catch (e) {
      return Result.failure(CacheFailure('添加收藏失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> deleteFavorite(String uuid) async {
    try {
      await $isar.writeTxn(() async {
        final List<FavoriteModel> models = await $isar.favorites
            .where()
            .filter()
            .uuidEqualTo(uuid)
            .findAll();
        for (final FavoriteModel e in models) {
          if (e.id != null) await $isar.favorites.delete(e.id!);
        }
      });
      return Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure('删除收藏失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<bool, Failure>> isFavorite(String movieId) async {
    try {
      final List<FavoriteModel> models = await $isar.favorites
          .where()
          .filter()
          .movieIdEqualTo(movieId)
          .findAll();
      return Result.success(models.isNotEmpty);
    } catch (e) {
      return Result.failure(CacheFailure('检查收藏失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> unfavorite(String movieId) async {
    try {
      await $isar.writeTxn(() async {
        final List<FavoriteModel> models = await $isar.favorites
            .where()
            .filter()
            .movieIdEqualTo(movieId)
            .findAll();
        for (final FavoriteModel e in models) {
          if (e.id != null) await $isar.favorites.delete(e.id!);
        }
      });
      return Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure('取消收藏失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Settings, Failure>> getSettings() async {
    try {
      final List<SettingsModel> models = await $isar.settings.where().findAll();
      if (models.isEmpty) {
        // 返回默认设置
        final now = DateTime.now();
        final defaultSettings = Settings(
          uuid: 'default',
          defaultVolume: 100.0,
          defaultPlaybackSpeed: 1.0,
          autoPlayNext: true,
          themeMode: AppThemeMode.system,
          language: 'zh_CN',
          createdAt: now,
          updatedAt: now,
        );
        return Result.success(defaultSettings);
      }
      return Result.success(models.first.toEntity());
    } catch (e) {
      return Result.failure(CacheFailure('获取设置失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Settings, Failure>> saveSettings(Settings settings) async {
    try {
      final now = DateTime.now();
      final model = SettingsModel(
        uuid: settings.uuid,
        defaultVolume: settings.defaultVolume,
        defaultPlaybackSpeed: settings.defaultPlaybackSpeed,
        autoPlayNext: settings.autoPlayNext,
        themeMode: _themeModeToString(settings.themeMode),
        language: settings.language,
        createdAt: settings.createdAt ?? now,
        updatedAt: now,
      );
      await $isar.writeTxn(() async => $isar.settings.put(model));
      return Result.success(model.toEntity());
    } catch (e) {
      return Result.failure(CacheFailure('保存设置失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Settings, Failure>> updateSettings(Settings settings) async {
    try {
      final now = DateTime.now();
      final model = SettingsModel(
        uuid: settings.uuid,
        defaultVolume: settings.defaultVolume,
        defaultPlaybackSpeed: settings.defaultPlaybackSpeed,
        autoPlayNext: settings.autoPlayNext,
        themeMode: _themeModeToString(settings.themeMode),
        language: settings.language,
        createdAt: settings.createdAt,
        updatedAt: now,
      );
      await $isar.writeTxn(() async => $isar.settings.put(model));
      return Result.success(model.toEntity());
    } catch (e) {
      return Result.failure(CacheFailure('更新设置失败: ${e.toString()}'));
    }
  }

  String _themeModeToString(AppThemeMode mode) {
    switch (mode) {
      case AppThemeMode.light:
        return 'light';
      case AppThemeMode.dark:
        return 'dark';
      default:
        return 'system';
    }
  }
}
