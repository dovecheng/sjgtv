import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/watch_history.dart';
import 'package:sjgtv/domain/repositories/watch_history_repository.dart';

/// 获取所有观看历史 Use Case
class GetAllWatchHistoriesUseCase {
  const GetAllWatchHistoriesUseCase(this.repository);

  final WatchHistoryRepository repository;

  /// 获取所有观看历史
  Future<Result<List<WatchHistory>, Failure>> call() async {
    return repository.getAllHistories();
  }
}
