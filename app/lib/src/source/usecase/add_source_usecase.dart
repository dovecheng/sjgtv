import 'package:sjgtv/src/app/errors/failures.dart';
import 'package:sjgtv/src/app/errors/result.dart';
import 'package:sjgtv/src/core/usecase/use_case.dart';
import 'package:sjgtv/src/source/model/source_model.dart';

/// 添加源参数
class AddSourceParams {
  const AddSourceParams({
    required this.source,
  });

  final SourceModel source;
}

/// 添加源 Use Case
class AddSourceUseCase implements UseCase<AddSourceParams, SourceModel> {
  AddSourceUseCase({
    required Future<SourceModel> Function(SourceModel) addSource,
  }) : _addSource = addSource;

  final Future<SourceModel> Function(SourceModel) _addSource;

  @override
  Future<Result<SourceModel, Failure>> call(AddSourceParams params) async {
    try {
      final source = await _addSource(params.source);
      return Result.success(source);
    } catch (e) {
      return Result.failure(
        CacheFailure('添加源失败: ${e.toString()}'),
      );
    }
  }
}