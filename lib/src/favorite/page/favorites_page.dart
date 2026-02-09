import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sjgtv/core/core.dart';
import 'package:sjgtv/src/movie/widget/network_image_placeholders.dart';
import 'package:sjgtv/src/favorite/provider/favorites_provider.dart';
import 'package:sjgtv/l10n_gen/app_localizations.dart';

/// 收藏列表页面
class FavoritesPage extends ConsumerWidget {
  const FavoritesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    final l10n = AppLocalizations.of(context);

    final favoritesAsync = ref.watch(favoritesProvider);

    return Scaffold(
      appBar: AppBar(
        title: Text(l10n.favorites),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            onPressed: favoritesAsync.when(
              data: (favorites) {
                if (favorites.isEmpty) return null;
                return () => _showClearAllDialog(context, ref);
              },
              loading: () => null,
              error: (_, error) => null,
            ),
            tooltip: l10n.clearAll,
          ),
        ],
      ),
      body: favoritesAsync.when(
        data: (favorites) {
          if (favorites.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.favorite_border,
                    size: 64,
                    color: colorScheme.onSurfaceVariant,
                  ),
                  const SizedBox(height: 16),
                  Text(
                    l10n.noFavorites,
                    style: textTheme.titleLarge?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ],
              ),
            );
          }

          return GridView.builder(
            padding: const EdgeInsets.all(16),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 6,
              childAspectRatio: 0.7,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
            ),
            itemCount: favorites.length,
            itemBuilder: (context, index) {
              final favorite = favorites[index];
              return _FavoriteCard(
                favorite: favorite,
                onTap: () {
                  log.d(() => '用户点击删除收藏: ${favorite.movieTitle}');
                  _showDeleteDialog(context, ref, favorite);
                },
              );
            },
          );
        },
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, error) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 64),
              const SizedBox(height: 16),
              Text('加载失败', style: textTheme.titleLarge),
            ],
          ),
        ),
      ),
    );
  }

  void _showClearAllDialog(BuildContext context, WidgetRef ref) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.clearAllFavorites),
        content: Text(l10n.clearAllFavoritesConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              await ref.read(favoritesProvider.notifier).clearAll();
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }

  void _showDeleteDialog(
    BuildContext context,
    WidgetRef ref,
    dynamic favorite,
  ) {
    final l10n = AppLocalizations.of(context);
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(l10n.delete),
        content: Text(l10n.deleteFavoriteConfirm),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text(l10n.cancel),
          ),
          TextButton(
            onPressed: () async {
              await ref
                  .read(favoritesProvider.notifier)
                  .deleteFavorite(favorite.uuid);
              if (context.mounted) Navigator.pop(context);
            },
            child: Text(l10n.confirm),
          ),
        ],
      ),
    );
  }
}

class _FavoriteCard extends StatelessWidget {
  final dynamic favorite;
  final VoidCallback onTap;

  const _FavoriteCard({required this.favorite, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = context.theme;
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;

    return FocusableActionDetector(
      onFocusChange: (hasFocus) {
        // Focus handling can be added here
      },
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          decoration: BoxDecoration(
            color: colorScheme.surfaceContainerHighest,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: colorScheme.outlineVariant, width: 1),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8),
                  ),
                  child: favorite.movieCoverUrl.isNotEmpty
                      ? CachedImage(
                          imageUrl: favorite.movieCoverUrl,
                          fit: BoxFit.cover,
                          placeholder: (ctx, url) =>
                              networkImagePlaceholder(ctx),
                          errorWidget: (ctx, url, error) =>
                              networkImageErrorWidget(ctx),
                        )
                      : Container(
                          color: colorScheme.surfaceContainer,
                          child: Icon(
                            Icons.movie,
                            size: 48,
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      favorite.movieTitle,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: textTheme.titleSmall,
                    ),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Icon(Icons.star, size: 14, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          favorite.movieRating.toStringAsFixed(1),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          favorite.movieYear.toString(),
                          style: textTheme.bodySmall?.copyWith(
                            color: colorScheme.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
