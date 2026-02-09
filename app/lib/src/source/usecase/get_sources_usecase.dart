import '../../../core/base.dart';
import 'package:sjgtv/src/source/model/source_model.dart';

/// 获取源列表结果
class GetSourcesResult {
  const GetSourcesResult({
    required this.sources,
  });

  final List<SourceModel> sources;
}

/// 获取源列表 Use Case
class GetSourcesUseCase implements UseCase<NoParams, GetSourcesResult> {
  GetSourcesUseCase({
    required Future<List<SourceModel>> Function() getSources,
  }) : _getSources = getSources;

  final Future<List<SourceModel>> Function() _getSources;

  @override
  Future<Result<GetSourcesResult, Failure>> call(NoParams params) async {
    try {
      final sources = await _getSources();
      return Result.success(GetSourcesResult(sources: sources));
    } catch (e) {
      return Result.failure(
        CacheFailure('获取源列表失败: ${e.toString()}'),
      );
    }
  }
}