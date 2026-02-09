
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';
import 'package:isar_community/isar.dart';

import '../../../core/arch/errors/failures.dart';
import '../../../core/arch/errors/result.dart';
import '../../domain/entities/source.dart';
import '../../domain/entities/proxy.dart';
import '../../domain/entities/tag.dart';
import '../../domain/entities/watch_history.dart';
import '../datasources/local_datasource.dart';
import '../../../core/isar/isar.dart';
import '../../../src/source/model/source_model.dart';
import '../../../src/proxy/model/proxy_model.dart';
import '../../../src/tag/model/tag_model.dart';
import '../../../src/watch_history/model/watch_history_model.dart';

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
}
