import '../../../core/arch/errors/failures.dart';
import '../../../core/arch/errors/result.dart';
import '../../domain/entities/source.dart';
import '../../domain/repositories/source_repository.dart';
import '../datasources/local_datasource.dart';

/// 视频源仓库实现
///
/// 实现 SourceRepository 接口，提供视频源数据的访问功能
class SourceRepositoryImpl implements SourceRepository {
  SourceRepositoryImpl({
    required this.localDataSource,
  });

  final LocalDataSource localDataSource;

  @override
  Future<Result<List<Source>, Failure>> getAllSources() async {
    return localDataSource.getAllSources();
  }

  @override
  Future<Result<List<Source>, Failure>> getSourcesByTag(String tagId) async {
    final result = await getAllSources();
    if (result.isFailure) {
      return Result.failure(result.error!);
    }

    final sources = result.value!.where((s) => s.tagIds.contains(tagId)).toList();
    return Result.success(sources);
  }

  @override
  Future<Result<Source, Failure>> addSource(Source source) async {
    return localDataSource.addSource(source);
  }

  @override
  Future<Result<Source, Failure>> updateSource(Source source) async {
    return localDataSource.updateSource(source);
  }

  @override
  Future<Result<void, Failure>> deleteSource(String uuid) async {
    return localDataSource.deleteSource(uuid);
  }

  @override
  Future<Result<Source, Failure>> toggleSource(String uuid) async {
    // 获取当前源
    final sourcesResult = await getAllSources();
    if (sourcesResult.isFailure) {
      return Result.failure(sourcesResult.error!);
    }

    final sources = sourcesResult.value!;
    final source = sources.cast<Source?>().firstWhere((s) => s?.uuid == uuid, orElse: () => null);

    if (source == null) {
      return Result.failure(const NotFoundFailure('视频源不存在'));
    }

    // 切换状态
    final updated = source.copyWith(disabled: !source.disabled);
    return updateSource(updated);
  }

  @override
  Future<Result<bool, Failure>> testSource(String uuid) async {
    // TODO: 实现测试视频源连接
    return Result.success(true);
  }
}