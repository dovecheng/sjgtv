import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/watch_history.dart';

/// 观看历史仓库接口
///
/// 定义观看历史数据的访问方法
abstract class WatchHistoryRepository {
  /// 添加或更新观看历史
  ///
  /// [history] 观看历史实体
  Future<Result<WatchHistory, Failure>> addOrUpdateHistory(
    WatchHistory history,
  );

  /// 获取所有观看历史（按观看时间降序）
  Future<Result<List<WatchHistory>, Failure>> getAllHistories();

  /// 获取指定电影的观看历史
  ///
  /// [movieId] 电影 ID
  Future<Result<List<WatchHistory>, Failure>> getHistoriesByMovie(
    String movieId,
  );

  /// 删除观看历史
  ///
  /// [id] 历史 ID
  Future<Result<void, Failure>> deleteHistory(String id);

  /// 清除所有观看历史
  Future<Result<void, Failure>> clearAllHistories();
}
