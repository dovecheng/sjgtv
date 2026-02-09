import '../../../core/arch/errors/failures.dart';
import '../../../core/arch/errors/result.dart';
import '../entities/source.dart';
import '../repositories/source_repository.dart';

/// 获取所有视频源 Use Case
///
/// 领域层的业务逻辑，通过仓库接口获取所有视频源
class GetAllSourcesUseCase {
  const GetAllSourcesUseCase(this.repository);

  final SourceRepository repository;

  /// 执行获取
  Future<Result<List<Source>, Failure>> call() async {
    return repository.getAllSources();
  }
}