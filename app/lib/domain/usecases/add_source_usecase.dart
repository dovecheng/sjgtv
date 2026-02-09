import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/source.dart';
import 'package:sjgtv/domain/repositories/source_repository.dart';

/// 添加视频源参数
class AddSourceParams {
  const AddSourceParams({
    required this.name,
    required this.url,
    this.weight = 5,
    this.disabled = false,
    this.tagIds = const [],
  });

  final String name;
  final String url;
  final int weight;
  final bool disabled;
  final List<String> tagIds;
}

/// 添加视频源 Use Case
///
/// 领域层的业务逻辑，通过仓库接口添加视频源
class AddSourceUseCase {
  const AddSourceUseCase(this.repository);

  final SourceRepository repository;

  /// 执行添加
  ///
  /// [params] 添加参数
  Future<Result<Source, Failure>> call(AddSourceParams params) async {
    final now = DateTime.now();
    final source = Source(
      uuid: DateTime.now().millisecondsSinceEpoch.toString(),
      name: params.name,
      url: params.url,
      weight: params.weight,
      disabled: params.disabled,
      tagIds: params.tagIds,
      createdAt: now,
      updatedAt: now,
    );

    return repository.addSource(source);
  }
}