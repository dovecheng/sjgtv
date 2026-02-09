import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/watch_history.dart';
import 'package:sjgtv/domain/repositories/watch_history_repository.dart';

/// 保存观看历史参数
class SaveWatchHistoryParams {
  const SaveWatchHistoryParams({
    required this.history,
  });

  final WatchHistory history;
}

/// 保存观看历史 Use Case
class SaveWatchHistoryUseCase {
  const SaveWatchHistoryUseCase(this.repository);

  final WatchHistoryRepository repository;

  /// 保存观看历史
  Future<Result<WatchHistory, Failure>> call(SaveWatchHistoryParams params) async {
    return repository.addOrUpdateHistory(params.history);
  }
}