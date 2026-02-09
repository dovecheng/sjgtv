import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sjgtv/core/log/log.dart';
import 'package:sjgtv/core/network/network_status.dart';
import 'package:sjgtv/src/favorite/provider/favorites_provider.dart';
import 'package:sjgtv/src/watch_history/provider/watch_histories_provider.dart';

/// 离线模式管理器
///
/// 管理离线状态，提供缓存数据作为降级方案
class OfflineManager {
  final Log log = (OfflineManager).log;

  static OfflineManager? _instance;

  static OfflineManager get instance => _instance ??= OfflineManager._();

  OfflineManager._();

  /// 检查是否应该使用离线模式
  bool shouldUseOfflineMode() {
    return NetworkStatus.instance.isOffline;
  }

  /// 获取离线数据建议
  String getOfflineDataSuggestion() {
    final isOffline = NetworkStatus.instance.isOffline;
    if (isOffline) {
      return '当前离线，显示已缓存的内容';
    }
    return '网络正常';
  }

  /// 获取可用的离线数据统计
  Future<OfflineDataStats> getOfflineStats(Ref ref) async {
    try {
      final favoritesAsync = ref.read(favoritesProvider);
      final historiesAsync = ref.read(watchHistoriesProvider);

      final favoritesCount = favoritesAsync.maybeWhen(
        data: (favorites) => favorites.length,
        orElse: () => 0,
      );

      final historiesCount = historiesAsync.maybeWhen(
        data: (histories) => histories.length,
        orElse: () => 0,
      );

      return OfflineDataStats(
        favoritesCount: favoritesCount,
        historiesCount: historiesCount,
        isOffline: NetworkStatus.instance.isOffline,
      );
    } catch (e) {
      log.e(() => '获取离线数据统计失败', e);
      return OfflineDataStats(
        favoritesCount: 0,
        historiesCount: 0,
        isOffline: NetworkStatus.instance.isOffline,
      );
    }
  }
}

/// 离线数据统计
class OfflineDataStats {
  final int favoritesCount;
  final int historiesCount;
  final bool isOffline;

  OfflineDataStats({
    required this.favoritesCount,
    required this.historiesCount,
    required this.isOffline,
  });

  int get totalCachedItems => favoritesCount + historiesCount;

  bool get hasCachedData => totalCachedItems > 0;

  String get summary {
    if (isOffline) {
      return '离线模式 - 已缓存 $totalCachedItems 项内容';
    }
    return '在线模式';
  }
}

/// 离线模式状态 Provider
final offlineManagerProvider = Provider<OfflineManager>((ref) {
  return OfflineManager.instance;
});

/// 离线数据统计 Provider
final offlineStatsProvider = FutureProvider<OfflineDataStats>((ref) async {
  return ref.read(offlineManagerProvider).getOfflineStats(ref);
});

/// 是否使用离线模式 Provider
final isOfflineModeProvider = Provider<bool>((ref) {
  return ref.read(offlineManagerProvider).shouldUseOfflineMode();
});
