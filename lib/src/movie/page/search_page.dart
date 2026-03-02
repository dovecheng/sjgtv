import 'dart:async';

import 'package:sjgtv/core/core.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:sjgtv/domain/entities/movie.dart';
import 'package:sjgtv/src/app/constants/app_constants.dart';
import 'package:sjgtv/src/app/router/app_routes.dart';
import 'package:sjgtv/src/movie/provider/search_provider.dart';
import 'package:sjgtv/src/movie/widget/network_image_placeholders.dart';
import 'package:sjgtv/src/app/utils/tv_mode.dart';
import 'package:sjgtv/src/app/widget/focus_indicator.dart';
import 'package:flutter_animate/flutter_animate.dart';

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

class _SearchPageState extends ConsumerState<SearchPage> with FocusHelperMixin {
  MovieSearchService get _searchService => ref.read(movieSearchProvider);
  final CancelToken _cancelToken = CancelToken();
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();
  final FocusNode _searchButtonFocusNode = FocusNode();
  final ScrollController _gridScrollController = ScrollController();
  final List<FocusNode> _resultFocusNodes = <FocusNode>[];
  final List<GlobalKey> _resultItemKeys = <GlobalKey>[];
  List<Movie> _movies = [];
  int? _focusedResultIndex;
  bool _isLoading = false;
  bool _showSearchHint = true;
  Timer? _searchDebounceTimer;
  static const String _focusMemoryKey = 'search_page_focus';
  bool get _isHeroEntry =>
      widget.initialQuery != null && widget.initialQuery!.isNotEmpty;
  bool get _isSearchBarFocused =>
      _searchFocusNode.hasFocus || _searchButtonFocusNode.hasFocus;

  @override
  void initState() {
    super.initState();
    if (_isHeroEntry) {
      _searchController.text = widget.initialQuery!;
      _searchMovies(widget.initialQuery!);
      // 从首页 Hero 进入搜索时默认不弹出软键盘
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        _searchFocusNode.unfocus();
        _searchButtonFocusNode.requestFocus();
      });
    }
    _searchFocusNode.addListener(_onFocusChange);
    _searchButtonFocusNode.addListener(_onFocusChange);
    _searchController.addListener(_onSearchTextChange);

    // 仅在非 Hero 导航场景恢复焦点记忆
    if (!_isHeroEntry) {
      restoreSavedFocus(_focusMemoryKey);
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // 初始化 TV 模式
    TVModeConfig.init(context);
  }

  void _onFocusChange() {
    log.v(() => '搜索框焦点变化: hasFocus=${_searchFocusNode.hasFocus}');
    setState(() {});
  }

  void _onSearchTextChange() {
    setState(() {
      _showSearchHint = _searchController.text.isEmpty;
    });

    // 防抖搜索
    if (TVModeConfig.enableDebounce) {
      _searchDebounceTimer?.cancel();
      _searchDebounceTimer = Timer(TVModeConfig.debounceDuration, () {
        if (_searchController.text.isNotEmpty) {
          _searchMovies(_searchController.text.trim());
        }
      });
    }
  }

  @override
  void dispose() {
    // 保存当前焦点
    saveCurrentFocus(_focusMemoryKey);
    _searchFocusNode.removeListener(_onFocusChange);
    _searchButtonFocusNode.removeListener(_onFocusChange);
    _searchController.dispose();
    _searchFocusNode.dispose();
    _searchButtonFocusNode.dispose();
    _gridScrollController.dispose();
    for (final FocusNode node in _resultFocusNodes) {
      node.dispose();
    }
    _resultFocusNodes.clear();
    _resultItemKeys.clear();
    _cancelToken.cancel();
    _searchDebounceTimer?.cancel();
    super.dispose();
  }

  void _ensureResultFocusData(int count) {
    while (_resultFocusNodes.length < count) {
      _resultFocusNodes.add(FocusNode());
    }
    while (_resultItemKeys.length < count) {
      _resultItemKeys.add(GlobalKey());
    }
    if (_resultFocusNodes.length > count) {
      for (int i = count; i < _resultFocusNodes.length; i++) {
        _resultFocusNodes[i].dispose();
      }
      _resultFocusNodes.removeRange(count, _resultFocusNodes.length);
    }
    if (_resultItemKeys.length > count) {
      _resultItemKeys.removeRange(count, _resultItemKeys.length);
    }
    if (_focusedResultIndex != null && _focusedResultIndex! >= count) {
      _focusedResultIndex = null;
    }
  }

  void _focusResultAt(int targetIndex) {
    if (targetIndex < 0 || targetIndex >= _resultFocusNodes.length) return;
    final FocusNode node = _resultFocusNodes[targetIndex];
    node.requestFocus();
    if (mounted) {
      setState(() {
        _focusedResultIndex = targetIndex;
      });
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final BuildContext? ctx = _resultItemKeys[targetIndex].currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 220),
          curve: Curves.easeInOut,
          alignment: 0.2,
        );
      }
    });
  }

  void _openMovieDetail(Movie movie) {
    final Map<String, dynamic> movieMap = <String, dynamic>{
      'vod_id': movie.id,
      'vod_name': movie.title,
      'vod_pic': movie.coverUrl,
      'vod_year': movie.year.toString(),
      'url': movie.url,
    };
    GoRouter.of(context).push(AppRoutes.movieDetail, extra: movieMap);
  }

  KeyEventResult _handleResultNavigationKey(
    KeyEvent event,
    int index,
    int crossAxisCount,
    Movie movie,
  ) {
    if (event is! KeyDownEvent) {
      return KeyEventResult.ignored;
    }
    final int column = index % crossAxisCount;

    if (event.logicalKey == LogicalKeyboardKey.arrowLeft) {
      if (column > 0) {
        _focusResultAt(index - 1);
      }
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowRight) {
      final int rightIndex = index + 1;
      final bool isSameRow =
          rightIndex < _movies.length && rightIndex % crossAxisCount != 0;
      if (isSameRow) {
        _focusResultAt(rightIndex);
      }
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowUp) {
      final int upIndex = index - crossAxisCount;
      if (upIndex >= 0) {
        _focusResultAt(upIndex);
      } else {
        _searchButtonFocusNode.requestFocus();
      }
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.arrowDown) {
      final int downIndex = index + crossAxisCount;
      if (downIndex < _movies.length) {
        _focusResultAt(downIndex);
      }
      return KeyEventResult.handled;
    }
    if (event.logicalKey == LogicalKeyboardKey.select ||
        event.logicalKey == LogicalKeyboardKey.enter) {
      log.v(() => '用户按键选择电影: ${movie.title}');
      _openMovieDetail(movie);
      return KeyEventResult.handled;
    }

    return KeyEventResult.ignored;
  }

  Future<void> _searchMovies(String keyword) async {
    if (keyword.isEmpty) {
      log.w(() => '搜索关键词为空，跳过搜索');
      return;
    }

    log.i(() => '开始搜索电影: keyword="$keyword"');
    setState(() {
      _isLoading = true;
      _movies = [];
    });

    try {
      final Map<String, dynamic> result = await _searchService.search(
        keyword,
        limit: 100,
      );

      if (mounted) {
        setState(() {
          _movies = result['list'] as List<Movie>? ?? [];
        });
        log.v(() => '搜索完成: 找到 ${_movies.length} 个结果');
      }
    } catch (e) {
      if (e is DioException && e.type == DioExceptionType.cancel) {
        log.v(() => '搜索已取消');
        return;
      }
      if (mounted) {
        log.e(() => '搜索失败: ${e.toString()}');
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
            border: _isSearchBarFocused
                ? Border.all(color: colorScheme.primary, width: 3)
                : null,
            boxShadow: _isSearchBarFocused
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
                  child: Focus(
                    focusNode: _searchFocusNode,
                    onKeyEvent: (FocusNode node, KeyEvent event) {
                      if (event is KeyDownEvent &&
                          event.logicalKey == LogicalKeyboardKey.arrowDown &&
                          _movies.isNotEmpty) {
                        _focusResultAt(0);
                        return KeyEventResult.handled;
                      }
                      return KeyEventResult.ignored;
                    },
                    child: TextField(
                      controller: _searchController,
                      style: const TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                      decoration: InputDecoration(
                        hintText: '搜索电影、电视剧...',
                        hintStyle: TextStyle(
                          fontSize: 22,
                          color: colorScheme.onSurfaceVariant,
                        ),
                        border: InputBorder.none,
                        enabledBorder: InputBorder.none,
                        focusedBorder: InputBorder.none,
                        disabledBorder: InputBorder.none,
                        errorBorder: InputBorder.none,
                        focusedErrorBorder: InputBorder.none,
                      ),
                      onSubmitted: (value) {
                        _searchMovies(value.trim());
                      },
                    ),
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
    return Focus(
      focusNode: _searchButtonFocusNode,
      onKeyEvent: (node, event) {
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.arrowDown &&
            _movies.isNotEmpty) {
          _focusResultAt(0);
          return KeyEventResult.handled;
        }
        if (event is KeyDownEvent &&
            event.logicalKey == LogicalKeyboardKey.select) {
          log.d(() => '用户按键触发搜索: keyword="${_searchController.text.trim()}"');
          _searchMovies(_searchController.text.trim());
          return KeyEventResult.handled;
        }
        return KeyEventResult.ignored;
      },
      child: FocusIndicator(
        decoration: const FocusIndicatorDecoration(
          hasBorder: false,
          hasShadow: false,
          hasScale: true,
          scaleFactor: 1.05,
        ),
        onTap: () {
          log.d(() => '用户点击搜索按钮: keyword="${_searchController.text.trim()}"');
          _searchMovies(_searchController.text.trim());
        },
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                      color: colorScheme.onSurfaceVariant.withAlpha(
                        (255 * 0.3).toInt(),
                      ),
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
                        color: colorScheme.onSurfaceVariant.withAlpha(
                          (255 * 0.7).toInt(),
                        ),
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
                      color: colorScheme.onSurfaceVariant.withAlpha(
                        (255 * 0.3).toInt(),
                      ),
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
                        color: colorScheme.onSurfaceVariant.withAlpha(
                          (255 * 0.7).toInt(),
                        ),
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
        // 使用 TV 模式推荐的网格列数
        final int crossAxisCount = TVModeLayout.getRecommendedGridColumns(
          screenWidth: constraints.maxWidth,
        );
        _ensureResultFocusData(_movies.length);

        return Column(
          children: [
            Padding(
              padding: EdgeInsets.symmetric(
                horizontal: TVModeLayout.getRecommendedPagePadding(),
                vertical: 16,
              ),
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
              child: FocusTraversalGroup(
                policy: OrderedTraversalPolicy(),
                child: GridView.builder(
                  controller: _gridScrollController,
                  padding: EdgeInsets.symmetric(
                    horizontal: TVModeLayout.getRecommendedPagePadding(),
                    vertical: 8,
                  ),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: crossAxisCount,
                    childAspectRatio:
                        TVModeLayout.getRecommendedCardAspectRatio(),
                    crossAxisSpacing: TVModeLayout.getRecommendedCardSpacing(),
                    mainAxisSpacing: TVModeLayout.getRecommendedCardSpacing(),
                  ),
                  itemCount: _movies.length,
                  itemBuilder: (BuildContext ctx, int index) {
                    final Movie movie = _movies[index];
                    return _buildMovieCard(ctx, movie, index, crossAxisCount);
                  },
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildMovieCard(
    BuildContext context,
    Movie movie,
    int index,
    int crossAxisCount,
  ) {
    final bool isFocused = _focusedResultIndex == index;
    return KeyedSubtree(
      key: _resultItemKeys[index],
      child:
          FocusIndicator(
                key: ValueKey('search_result_${movie.id}'),
                focusNode: _resultFocusNodes[index],
                onKeyEvent: (FocusNode node, KeyEvent event) {
                  return _handleResultNavigationKey(
                    event,
                    index,
                    crossAxisCount,
                    movie,
                  );
                },
                decoration: const FocusIndicatorDecoration(
                  hasBorder: true,
                  hasShadow: true,
                  hasScale: false,
                  borderWidth: 2.5,
                  shadowBlurRadius: 12,
                  shadowSpreadRadius: 1.5,
                ),
                onFocusChange: (bool hasFocus) {
                  if (!mounted) return;
                  setState(() {
                    _focusedResultIndex = hasFocus
                        ? index
                        : _focusedResultIndex;
                  });
                },
                onTap: () {
                  log.v(() => '用户点击电影卡片: ${movie.title}');
                  _openMovieDetail(movie);
                },
                child: AnimatedScale(
                  duration: AppConstants.normalAnimation,
                  curve: Curves.easeOutBack,
                  scale: isFocused ? AppConstants.focusScaleFactor : 1.0,
                  child: AnimatedContainer(
                    duration: AppConstants.normalAnimation,
                    curve: Curves.easeOutCubic,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      boxShadow: [
                        BoxShadow(
                          color: isFocused
                              ? AppTheme.focusGlow.withValues(alpha: 0.9)
                              : Colors.transparent,
                          blurRadius: isFocused ? 10.0 : 0.0,
                          spreadRadius: isFocused ? 1.0 : 0.0,
                        ),
                      ],
                      border: Border.all(
                        color: isFocused
                            ? AppTheme.focus.withValues(alpha: 0.8)
                            : Colors.transparent,
                        width: isFocused ? AppConstants.focusBorderWidth : 0,
                      ),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Expanded(
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: CachedImage(
                              imageUrl: movie.coverUrl,
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
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8),
                          child: Text(
                            movie.title,
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            textAlign: TextAlign.center,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              )
              .animate(target: isFocused ? 1 : 0)
              .shimmer(
                duration: 1400.ms,
                color: AppTheme.focus.withValues(alpha: 0.1),
                angle: 45,
              ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop:
          _isHeroEntry ||
          (!_searchFocusNode.hasFocus && _searchController.text.isEmpty),
      onPopInvokedWithResult: (bool didPop, dynamic result) {
        if (!didPop) {
          _cancelToken.cancel();
          if (_isHeroEntry) {
            return;
          }
          if (_searchController.text.isNotEmpty && mounted) {
            setState(() {
              _movies.clear();
              _searchController.clear();
            });
            return;
          }
          if (_searchFocusNode.hasFocus) {
            _searchFocusNode.unfocus();
          }
        }
      },
      child: Focus(
        autofocus: true,
        onKeyEvent: (FocusNode node, KeyEvent event) {
          if (event is KeyDownEvent &&
              event.logicalKey == LogicalKeyboardKey.arrowDown &&
              _movies.isNotEmpty &&
              (_searchFocusNode.hasFocus || _searchButtonFocusNode.hasFocus)) {
            _focusResultAt(0);
            return KeyEventResult.handled;
          }
          return KeyEventResult.ignored;
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
      ),
    );
  }
}
