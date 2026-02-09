import '../../../core/arch/errors/failures.dart';
import '../../../core/arch/errors/result.dart';
import '../../domain/entities/watch_history.dart';
import '../../domain/repositories/watch_history_repository.dart';
import '../datasources/local_datasource.dart';

/// 观看历史仓库实现
class WatchHistoryRepositoryImpl implements WatchHistoryRepository {
  WatchHistoryRepositoryImpl({
    required this.localDataSource,
  });

  final LocalDataSource localDataSource;

  @override
  Future<Result<WatchHistory, Failure>> addOrUpdateHistory(
      WatchHistory history) async {
    return localDataSource.addOrUpdateWatchHistory(history);
  }

  @override
  Future<Result<List<WatchHistory>, Failure>> getAllHistories() async {
    return localDataSource.getAllWatchHistories();
  }

  @override
  Future<Result<List<WatchHistory>, Failure>> getHistoriesByMovie(
      String movieId) async {
    return localDataSource.getWatchHistoriesByMovie(movieId);
  }

  @override
  Future<Result<void, Failure>> deleteHistory(String id) async {
    return localDataSource.deleteWatchHistory(id);
  }

  @override
  Future<Result<void, Failure>> clearAllHistories() async {
    return localDataSource.clearAllWatchHistories();
  }
}