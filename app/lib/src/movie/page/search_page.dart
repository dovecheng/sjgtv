import 'package:base/cache.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sjgtv/src/movie/provider/search_provider.dart';
import 'package:base/app.dart';
import 'package:sjgtv/src/movie/widget/network_image_placeholders.dart';
import 'movie_detail_page.dart';

/// 电影搜索页
///
/// 功能：
/// - 通过本地 shelf 服务搜索电影（聚合多个数据源）
/// - TV 遥控器友好的搜索框和结果列表
/// - 点击电影卡片跳转到详情页
class SearchPage extends ConsumerStatefulWidget {
  final String? initialQuery;

  const SearchPage({super.key, this.initialQuery});

  @override
  ConsumerState<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends ConsumerState<SearchPage> {
  MovieSearchService get _searchService => ref.read(movieSearchProvider);
  final CancelToken _cancelToken = CancelToken();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  List<dynamic> _movies = [];
  bool _isLoading = false;
  bool _showSearchHint = true;

  @override
  void initState() {
    super.initState();

    if (widget.initialQuery != null) {
      _searchController.text = widget.initialQuery!;
      _searchMovies(widget.initialQuery!);
    }
    _searchFocusNode.addListener(_onFocusChange);
    _searchController.addListener(_onSearchTextChange);
  }

  void _onFocusChange() {
    setState(() {});
  }

  void _onSearchTextChange() {
    setState(() {
      _showSearchHint = _searchController.text.isEmpty;
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    _cancelToken.cancel();
    super.dispose();
  }

  Future<void> _searchMovies(String keyword) async {
    if (keyword.isEmpty) return;

    setState(() {
      _isLoading = true;
      _movies = [];
    });

    try {
      final Map<String, dynamic> result =
          await _searchService.search(keyword, limit: 100);

      if (mounted) {
        setState(() {
          _movies = result['list'] as List<dynamic>? ?? [];
        });
      }
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        return;
      }
      if (mounted) {
        _showError(context, '搜索失败: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(BuildContext context, String message) {
    final ColorScheme colorScheme = context.theme.colorScheme;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        ),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 3),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        backgroundColor: colorScheme.error,
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
      ),
    );
  }

  Widget _buildSearchField(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;
    return Padding(
      padding: const EdgeInsets.fromLTRB(48, 32, 48, 24),
      child: Material(
        elevation: 8,
        borderRadius: BorderRadius.circular(32),
        color: colorScheme.surfaceContainerHighest,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            border: _searchFocusNode.hasFocus
                ? Border.all(color: colorScheme.primary, width: 3)
                : null,
            boxShadow: _searchFocusNode.hasFocus
                ? [
                    BoxShadow(
                      color: colorScheme.primary.withAlpha((255 * 0.3).toInt()),
                      blurRadius: 12,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Row(
            children: [
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 24),
                  child: TextField(
                    focusNode: _searchFocusNode,
                    controller: _searchController,
                    style: const TextStyle(
                      fontSize: 24,
                      color: Colors.white,
                      fontWeight: FontWeight.w500,
                    ),
                    decoration: InputDecoration(
                      hintText: '搜索电影、电视剧...',
                      hintStyle: TextStyle(fontSize: 22, color: colorScheme.onSurfaceVariant),
                      border: InputBorder.none,
                    ),
                    onSubmitted: (value) {
                      _searchMovies(value.trim());
                    },
                  ),
                ),
              ),
              _buildSearchButton(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSearchButton(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;
    return Row(
      children: [
        Focus(
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent &&
                event.logicalKey == LogicalKeyboardKey.select) {
              _searchMovies(_searchController.text.trim());
              return KeyEventResult.handled;
            }
            return KeyEventResult.ignored;
          },
          child: Builder(
            builder: (BuildContext ctx) {
              final bool hasFocus = Focus.of(ctx).hasFocus;
              return AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                margin: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                color: hasFocus ? colorScheme.primary : colorScheme.surfaceContainerLow,
                borderRadius: BorderRadius.circular(24),
                boxShadow: hasFocus
                    ? [
                        BoxShadow(
                          color: colorScheme.primary.withAlpha(255 ~/ 2),
                            blurRadius: 12,
                            spreadRadius: 2,
                          ),
                        ]
                      : null,
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(24),
                  onTap: () => _searchMovies(_searchController.text.trim()),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 16,
                    ),
                    child: Row(
                      children: [
                        const Icon(Icons.search, size: 32, color: Colors.white),
                        const SizedBox(width: 8),
                        const Text(
                          '搜索',
                          style: TextStyle(
                            fontSize: 22,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildContent(BuildContext context) {
    final ColorScheme colorScheme = context.theme.colorScheme;
    if (_isLoading) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              strokeWidth: 6,
              valueColor: AlwaysStoppedAnimation<Color>(colorScheme.primary),
            ),
            const SizedBox(height: 32),
            Text(
              '正在搜索中...',
              style: TextStyle(
                fontSize: 24,
                color: Colors.white.withAlpha((255 * 0.8).toInt()),
              ),
            ),
          ],
        ),
      );
    }

    if (_movies.isEmpty) {
      return _showSearchHint
          ? Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.movie_creation,
                      size: 120,
                      color: colorScheme.onSurfaceVariant.withAlpha((255 * 0.3).toInt()),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      '输入电影或电视剧名称',
                      style: TextStyle(
                        fontSize: 28,
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '使用遥控器方向键导航，确认键选择',
                      style: TextStyle(
                        fontSize: 20,
                        color: colorScheme.onSurfaceVariant.withAlpha((255 * 0.7).toInt()),
                      ),
                    ),
                  ],
                ),
              ),
            )
          : Center(
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Icon(
                      Icons.search_off,
                      size: 120,
                      color: colorScheme.onSurfaceVariant.withAlpha((255 * 0.3).toInt()),
                    ),
                    const SizedBox(height: 32),
                    Text(
                      '没有找到相关内容',
                      style: TextStyle(
                        fontSize: 28,
                        color: colorScheme.onSurfaceVariant,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      '尝试其他关键词',
                      style: TextStyle(
                        fontSize: 20,
                        color: colorScheme.onSurfaceVariant.withAlpha((255 * 0.7).toInt()),
                      ),
                    ),
                  ],
                ),
              ),
            );
    }

    return _buildMovieGrid(context);
  }

  Widget _buildMovieGrid(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final int crossAxisCount = (constraints.maxWidth / 200).floor().clamp(2, 6);

        return Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 48, vertical: 16),
              child: Row(
                children: [
                  Text(
                    '搜索结果 (${_movies.length})',
                    style: TextStyle(
                      fontSize: 22,
                      color: Colors.white.withAlpha((255 * 0.8).toInt()),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.symmetric(
                  horizontal: 48,
                  vertical: 8,
                ),
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: crossAxisCount,
                  childAspectRatio: 0.7,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                ),
                itemCount: _movies.length,
                itemBuilder: (BuildContext ctx, int index) {
                  final dynamic movie = _movies[index];
                  return _buildMovieCard(ctx, movie);
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMovieCard(BuildContext context, Map<String, dynamic> movie) {
    final ColorScheme colorScheme = context.theme.colorScheme;
    return Focus(
      onKeyEvent: (FocusNode node, KeyEvent event) {
        if (event is KeyDownEvent &&
            (event.logicalKey == LogicalKeyboardKey.select ||
                event.logicalKey == LogicalKeyboardKey.enter)) {
          Navigator.push(
            context,
            MaterialPageRoute<void>(
              builder: (BuildContext ctx) => MovieDetailPage(movie: movie),
            ),
          );
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: Builder(
        builder: (BuildContext ctx) {
          final bool hasFocus = Focus.of(ctx).hasFocus;
          return AnimatedContainer(
            duration: const Duration(milliseconds: 200),
            margin: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              boxShadow: hasFocus
                  ? [
                      BoxShadow(
                        color: colorScheme.primary.withAlpha((255 * 0.4).toInt()),
                        blurRadius: 16,
                        spreadRadius: 4,
                      ),
                    ]
                  : [
                      BoxShadow(
                        color: Colors.black.withAlpha((255 * 0.4).toInt()),
                        blurRadius: 8,
                        spreadRadius: 2,
                      ),
                    ],
            ),
            child: Card(
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
                side: hasFocus
                    ? BorderSide(color: colorScheme.primary, width: 3)
                    : BorderSide.none,
              ),
              elevation: hasFocus ? 8 : 4,
              color: colorScheme.surfaceContainerHighest,
              clipBehavior: Clip.antiAlias,
              child: InkWell(
                borderRadius: BorderRadius.circular(12),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => MovieDetailPage(movie: movie),
                    ),
                  );
                },
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Expanded(
                      child: CachedImage(
                        imageUrl: movie['vod_pic'] ?? '',
                        fit: BoxFit.cover,
                        width: double.infinity,
                        placeholder: (BuildContext ctx, _) =>
                            networkImagePlaceholder(ctx),
                        errorWidget: (BuildContext ctx, _, _) =>
                            networkImageErrorWidget(ctx),
                        memCacheWidth: 200,
                        memCacheHeight: 300,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            movie['vod_name'] ?? '未知标题',
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Row(
                            children: [
                              if (movie['vod_year']?.toString().isNotEmpty ??
                                  false)
                                Flexible(
                                  child: Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 6,
                                      vertical: 2,
                                    ),
                                    decoration: BoxDecoration(
                                      color: colorScheme.primary.withAlpha(
                                        (255 * 0.2).toInt(),
                                      ),
                                      borderRadius: BorderRadius.circular(4),
                                    ),
                                    child: Text(
                                      movie['vod_year'].toString(),
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: colorScheme.primary,
                                      ),
                                    ),
                                  ),
                                ),
                              if (movie['type_name']?.toString().isNotEmpty ??
                                  false) ...[
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    movie['type_name'].toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                              ],
                              if (movie['vod_play_from']
                                      ?.toString()
                                      .isNotEmpty ??
                                  false) ...[
                                const SizedBox(width: 6),
                                Flexible(
                                  child: Text(
                                    '| ${movie['vod_play_from']}',
                                    style: TextStyle(
                                      fontSize: 12,
                                      color: colorScheme.onSurfaceVariant,
                                    ),
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ],
                      ),
                    ),
                    if (hasFocus)
                      Container(
                        height: 4,
                        decoration: BoxDecoration(
                          color: colorScheme.primary,
                          borderRadius: const BorderRadius.vertical(
                            bottom: Radius.circular(12),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: !_searchFocusNode.hasFocus && _searchController.text.isEmpty,
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) {
          _cancelToken.cancel();
          if (_searchFocusNode.hasFocus) {
            _searchFocusNode.unfocus();
          } else if (_searchController.text.isNotEmpty && mounted) {
            setState(() {
              _movies.clear();
              _searchController.clear();
            });
          }
        }
      },
      child: FocusScope(
        autofocus: true,
        child: Scaffold(
          appBar: PreferredSize(
            preferredSize: const Size(double.infinity, 200),
            child: _buildSearchField(context),
          ),
          backgroundColor: context.theme.colorScheme.surface,
          body: _buildContent(context),
        ),
      ),
    );
  }
}
