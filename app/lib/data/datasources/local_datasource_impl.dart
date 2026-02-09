
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import '../../../core/arch/errors/failures.dart';
import '../../../core/arch/errors/result.dart';
import '../../domain/entities/source.dart';
import '../../domain/entities/proxy.dart';
import '../../domain/entities/tag.dart';
import '../datasources/local_datasource.dart';
import '../../../src/source/model/source_model.dart';
import '../../../src/proxy/model/proxy_model.dart';
import '../../../src/tag/model/tag_model.dart';

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
      // TODO: 从 Isar 获取数据
      // 暂时返回空列表
      return Result.success([]);
    } catch (e) {
      return Result.failure(CacheFailure('获取视频源失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Source, Failure>> addSource(Source source) async {
    try {
      // TODO: 保存到 Isar
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

      return Result.success(model.toEntity());
    } catch (e) {
      return Result.failure(CacheFailure('添加视频源失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Source, Failure>> updateSource(Source source) async {
    try {
      // TODO: 更新到 Isar
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

      return Result.success(model.toEntity());
    } catch (e) {
      return Result.failure(CacheFailure('更新视频源失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> deleteSource(String uuid) async {
    try {
      // TODO: 从 Isar 删除
      return Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure('删除视频源失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<Proxy>, Failure>> getAllProxies() async {
    try {
      // TODO: 从 Isar 获取数据
      // 暂时返回空列表
      return Result.success([]);
    } catch (e) {
      return Result.failure(CacheFailure('获取代理失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Proxy, Failure>> addProxy(Proxy proxy) async {
    try {
      // TODO: 保存到 Isar
      final now = DateTime.now();
      final model = ProxyModel(
        uuid: proxy.uuid.isEmpty ? _uuid.v4() : proxy.uuid,
        url: proxy.url,
        name: proxy.name,
        enabled: proxy.enabled,
        createdAt: proxy.createdAt ?? now,
        updatedAt: now,
      );

      return Result.success(model.toEntity());
    } catch (e) {
      return Result.failure(CacheFailure('添加代理失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Proxy, Failure>> updateProxy(Proxy proxy) async {
    try {
      // TODO: 更新到 Isar
      final now = DateTime.now();
      final model = ProxyModel(
        uuid: proxy.uuid,
        url: proxy.url,
        name: proxy.name,
        enabled: proxy.enabled,
        createdAt: proxy.createdAt,
        updatedAt: now,
      );

      return Result.success(model.toEntity());
    } catch (e) {
      return Result.failure(CacheFailure('更新代理失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> deleteProxy(String uuid) async {
    try {
      // TODO: 从 Isar 删除
      return Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure('删除代理失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<List<Tag>, Failure>> getAllTags() async {
    try {
      // TODO: 从 Isar 获取数据
      // 暂时返回空列表
      return Result.success([]);
    } catch (e) {
      return Result.failure(CacheFailure('获取标签失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Tag, Failure>> addTag(Tag tag) async {
    try {
      // TODO: 保存到 Isar
      final now = DateTime.now();
      final model = TagModel(
        uuid: tag.uuid.isEmpty ? _uuid.v4() : tag.uuid,
        name: tag.name,
        color: tag.color,
        order: tag.order,
        createdAt: tag.createdAt ?? now,
        updatedAt: now,
      );

      return Result.success(model.toEntity());
    } catch (e) {
      return Result.failure(CacheFailure('添加标签失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<Tag, Failure>> updateTag(Tag tag) async {
    try {
      // TODO: 更新到 Isar
      final now = DateTime.now();
      final model = TagModel(
        uuid: tag.uuid,
        name: tag.name,
        color: tag.color,
        order: tag.order,
        createdAt: tag.createdAt,
        updatedAt: now,
      );

      return Result.success(model.toEntity());
    } catch (e) {
      return Result.failure(CacheFailure('更新标签失败: ${e.toString()}'));
    }
  }

  @override
  Future<Result<void, Failure>> deleteTag(String uuid) async {
    try {
      // TODO: 从 Isar 删除
      return Result.success(null);
    } catch (e) {
      return Result.failure(CacheFailure('删除标签失败: ${e.toString()}'));
    }
  }
}
