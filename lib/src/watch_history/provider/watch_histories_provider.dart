import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:sjgtv/domain/entities/watch_history.dart';
import 'package:sjgtv/domain/usecases/usecases.dart';
import 'package:sjgtv/di/domain_di.dart';

part 'watch_histories_provider.g.dart';

/// 观看历史提供者
///
/// 管理观看历史数据
@Riverpod(keepAlive: true)
class WatchHistoriesProvider extends _$WatchHistoriesProvider {
  @override
  Future<List<WatchHistory>> build() async {
    final useCase = ref.watch(getAllWatchHistoriesUseCaseProvider);
    final result = await useCase();
    return result.fold(
      (failure) => [],
      (histories) => histories,
    );
  }

  /// 添加或更新观看历史
  Future<void> addOrUpdateHistory(WatchHistory history) async {
    final useCase = SaveWatchHistoryUseCase(
      ref.watch(watchHistoryRepositoryProvider),
    );
    final result = await useCase(SaveWatchHistoryParams(history: history));
    result.fold(
      (failure) => null,
      (_) => ref.invalidateSelf(),
    );
  }

  /// 删除观看历史
  Future<void> deleteHistory(String id) async {
    final useCase = DeleteWatchHistoryUseCase(
      ref.watch(watchHistoryRepositoryProvider),
    );
    final result = await useCase(DeleteWatchHistoryParams(id: id));
    result.fold(
      (failure) => null,
      (_) => ref.invalidateSelf(),
    );
  }

  /// 清除所有观看历史
  Future<void> clearAll() async {
    final repository = ref.watch(watchHistoryRepositoryProvider);
    final result = await repository.clearAllHistories();
    result.fold(
      (failure) => null,
      (_) => ref.invalidateSelf(),
    );
  }
}