import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sjgtv/core/offline/offline.dart';

/// 离线模式横幅提示
class OfflineBanner extends ConsumerWidget {
  const OfflineBanner({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isOffline = ref.watch(offlineModeProvider);

    if (!isOffline) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      color: Colors.orange.withValues(alpha: 0.9),
      child: Row(
        children: [
          const Icon(Icons.wifi_off, color: Colors.white),
          const SizedBox(width: 8),
          const Expanded(
            child: Text(
              '当前处于离线模式，显示已缓存的内容',
              style: TextStyle(color: Colors.white),
            ),
          ),
          Consumer(
            builder: (context, ref, child) {
              final statsAsync = ref.watch(offlineStatsProvider);
              return statsAsync.when(
                data: (stats) {
                  if (stats.totalCachedItems > 0) {
                    return Text(
                      '已缓存 ${stats.totalCachedItems} 项',
                      style: const TextStyle(color: Colors.white, fontSize: 12),
                    );
                  }
                  return const SizedBox.shrink();
                },
                loading: () => const SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                  ),
                ),
                error: (error, stackTrace) => const SizedBox.shrink(),
              );
            },
          ),
        ],
      ),
    );
  }
}