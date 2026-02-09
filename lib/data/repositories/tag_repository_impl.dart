import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/tag.dart';
import 'package:sjgtv/domain/repositories/tag_repository.dart';
import 'package:sjgtv/data/datasources/local_datasource.dart';

/// 标签仓库实现
///
/// 实现 TagRepository 接口，提供标签数据的访问功能
class TagRepositoryImpl implements TagRepository {
  TagRepositoryImpl({required this.localDataSource});

  final LocalDataSource localDataSource;

  @override
  Future<Result<List<Tag>, Failure>> getAllTags() async {
    final result = await localDataSource.getAllTags();
    if (result.isFailure) {
      return Result.failure(result.error!);
    }

    final tags = result.value!..sort((a, b) => a.order.compareTo(b.order));
    return Result.success(tags);
  }

  @override
  Future<Result<List<Tag>, Failure>> getTagsByOrder(int order) async {
    final result = await getAllTags();
    if (result.isFailure) {
      return Result.failure(result.error!);
    }

    final tags = result.value!.where((t) => t.order == order).toList();
    return Result.success(tags);
  }

  @override
  Future<Result<Tag, Failure>> addTag(Tag tag) async {
    return localDataSource.addTag(tag);
  }

  @override
  Future<Result<Tag, Failure>> updateTag(Tag tag) async {
    return localDataSource.updateTag(tag);
  }

  @override
  Future<Result<void, Failure>> deleteTag(String uuid) async {
    return localDataSource.deleteTag(uuid);
  }

  @override
  Future<Result<void, Failure>> reorderTags(List<String> uuids) async {
    final result = await getAllTags();
    if (result.isFailure) {
      return Result.failure(result.error!);
    }

    final tags = result.value!;
    final tagMap = {for (var tag in tags) tag.uuid: tag};

    for (int i = 0; i < uuids.length; i++) {
      final tag = tagMap[uuids[i]];
      if (tag != null) {
        final updated = tag.copyWith(order: i);
        final updateResult = await updateTag(updated);
        if (updateResult.isFailure) {
          return Result.failure(updateResult.error!);
        }
      }
    }

    return Result.success(null);
  }
}
