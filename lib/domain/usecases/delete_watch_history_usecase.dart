import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/repositories/watch_history_repository.dart';

/// 删除观看历史参数
class DeleteWatchHistoryParams {
  const DeleteWatchHistoryParams({required this.id});

  final String id;
}

/// 删除观看历史 Use Case
class DeleteWatchHistoryUseCase {
  const DeleteWatchHistoryUseCase(this.repository);

  final WatchHistoryRepository repository;

  /// 删除观看历史
  Future<Result<void, Failure>> call(DeleteWatchHistoryParams params) async {
    return repository.deleteHistory(params.id);
  }
}
