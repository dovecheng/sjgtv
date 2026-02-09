import 'package:dio/dio.dart';
import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/source.dart';
import 'package:sjgtv/domain/repositories/source_repository.dart';
import 'package:sjgtv/data/datasources/local_datasource.dart';

/// 视频源仓库实现
///
/// 实现 SourceRepository 接口，提供视频源数据的访问功能
class SourceRepositoryImpl implements SourceRepository {
  SourceRepositoryImpl({
    required this.localDataSource,
    Dio? dio,
  }) : _dio = dio ?? Dio(BaseOptions(
          connectTimeout: const Duration(seconds: 10),
          receiveTimeout: const Duration(seconds: 10),
        ));

  final LocalDataSource localDataSource;
  final Dio _dio;

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
    try {
      final sourcesResult = await getAllSources();
      if (sourcesResult.isFailure) {
        return Result.failure(sourcesResult.error!);
      }

      final sources = sourcesResult.value!;
      final source = sources.cast<Source?>().firstWhere((s) => s?.uuid == uuid, orElse: () => null);

      if (source == null) {
        return Result.failure(const NotFoundFailure('视频源不存在'));
      }

      // 发送测试请求
      final response = await _dio.get<dynamic>(
        source.url,
        queryParameters: {'ac': 'list'},
        options: Options(
          headers: {
            'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36',
            'Accept': 'application/json, text/plain, */*',
          },
        ),
      );

      if (response.statusCode == 200) {
        final data = response.data;
        if (data is Map && (data['code'] == 1 || data['code'] == '1')) {
          return Result.success(true);
        }
      }

      return Result.success(false);
    } catch (e) {
      return Result.failure(NetworkFailure('测试视频源连接失败: ${e.toString()}'));
    }
  }
}