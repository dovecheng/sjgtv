import '../../../core/arch/errors/failures.dart';
import '../../../core/arch/errors/result.dart';
import '../entities/watch_history.dart';
import '../repositories/watch_history_repository.dart';

/// 获取所有观看历史 Use Case
class GetAllWatchHistoriesUseCase {
  const GetAllWatchHistoriesUseCase(this.repository);

  final WatchHistoryRepository repository;

  /// 获取所有观看历史
  Future<Result<List<WatchHistory>, Failure>> call() async {
    return repository.getAllHistories();
  }
}