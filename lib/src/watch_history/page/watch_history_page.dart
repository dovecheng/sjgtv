import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sjgtv/src/watch_history/provider/watch_histories_provider.dart';
import 'package:sjgtv/l10n_gen/app_localizations.dart';

/// 观看历史页面
class WatchHistoryPage extends ConsumerStatefulWidget {
  const WatchHistoryPage({super.key});

  @override
  ConsumerState<WatchHistoryPage> createState() => _WatchHistoryPageState();
}

class _WatchHistoryPageState extends ConsumerState<WatchHistoryPage> {
  final ScrollController _scrollController = ScrollController();

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.watchHistory),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_sweep),
            onPressed: () => _showClearAllDialog(context),
            tooltip: l10n.clearAll,
          ),
        ],
      ),
      body: ref
          .watch(watchHistoriesProvider)
          .when(
            data: (histories) {
              if (histories.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.history,
                        size: 80,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.3,
                        ),
                      ),
                      const SizedBox(height: 16),
                      Text(
                        l10n.noWatchHistory,
                        style: theme.textTheme.titleLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withValues(
                            alpha: 0.5,
                          ),
                        ),
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.all(16),
                itemCount: histories.length,
                itemBuilder: (context, index) {
                  final history = histories[index];
                  return _HistoryItem(
                    history: history,
                    onDelete: () => _deleteHistory(history.id),
                  );
                },
              );
            },
            loading: () => const Center(child: CircularProgressIndicator()),
            error: (error, stack) => Center(child: Text('错误: $error')),
          ),
    );
  }

  Future<void> _deleteHistory(String id) async {
    await ref.read(watchHistoriesProvider.notifier).deleteHistory(id);
  }

  Future<void> _showClearAllDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearAllHistory),
        content: Text(l10n.clearAllHistoryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              ref.read(watchHistoriesProvider.notifier).clearAll();
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }
}

/// 观看历史项
class _HistoryItem extends StatelessWidget {
  const _HistoryItem({required this.history, required this.onDelete});

  final dynamic history;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: InkWell(
        key: ValueKey('history_${history.id}'),
        onTap: () {
          // TODO: 跳转到播放器继续播放
        },
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // 封面
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Image.network(
                  history.movieCoverUrl,
                  width: 120,
                  height: 68,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      width: 120,
                      height: 68,
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: Icon(
                        Icons.movie,
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.3,
                        ),
                      ),
                    );
                  },
                ),
              ),
              const SizedBox(width: 12),
              // 信息
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      history.movieTitle,
                      style: theme.textTheme.titleMedium,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${history.episodeName} · ${history.sourceName}',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.onSurface.withValues(
                          alpha: 0.7,
                        ),
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        // 进度条
                        Expanded(
                          child: LinearProgressIndicator(
                            value: history.progressPercent / 100,
                            backgroundColor:
                                theme.colorScheme.surfaceContainerHighest,
                            valueColor: AlwaysStoppedAnimation(
                              theme.colorScheme.primary,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          '${history.progressPercent.toStringAsFixed(0)}%',
                          style: theme.textTheme.bodySmall?.copyWith(
                            color: theme.colorScheme.onSurface.withValues(
                              alpha: 0.7,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              // 观看时间
              Text(
                _formatWatchedTime(history.watchedAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
              ),
              const SizedBox(width: 8),
              // 删除按钮
              IconButton(
                key: const ValueKey('history_delete'),
                icon: Icon(
                  Icons.delete_outline,
                  color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
                ),
                onPressed: () => _showDeleteDialog(context),
                tooltip: l10n.delete,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatWatchedTime(DateTime watchedAt) {
    final now = DateTime.now();
    final difference = now.difference(watchedAt);

    if (difference.inDays > 0) {
      return '${difference.inDays}天前';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}小时前';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}分钟前';
    } else {
      return '刚刚';
    }
  }

  Future<void> _showDeleteDialog(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.deleteHistory),
        content: Text(l10n.deleteHistoryConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context);
              onDelete();
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }
}
