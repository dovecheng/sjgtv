import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sjgtv/core/core.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:sjgtv/src/app/router/app_routes.dart';
import 'package:sjgtv/src/movie/widget/network_image_placeholders.dart';
import 'package:sjgtv/src/favorite/provider/favorites_provider.dart';
import 'package:sjgtv/domain/entities/movie.dart';

/// 电影详情页
///
/// 功能：
/// - 显示电影海报、标题、年份、类型、主演、导演
/// - 显示剧情简介
/// - 解析播放地址并显示选集列表
/// - 支持 TV 遥控器导航（上下切换区域、左右切换选集）
/// - 点击选集跳转到全屏播放器
/// - 支持收藏/取消收藏
class MovieDetailPage extends ConsumerStatefulWidget {
  final dynamic movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  ConsumerState<MovieDetailPage> createState() => _MovieDetailPageState();

  /// 判断 movie 是否为 Map 类型
  bool get isMovieMap => movie is Map<String, dynamic>;

  /// 获取 movie 的 Map 表示
  Map<String, dynamic> get movieMap {
    log.d(() => 'movieMap called: movie type = ${movie.runtimeType}');
    if (isMovieMap) {
      log.d(() => 'movie is Map, returning directly');
      return movie as Map<String, dynamic>;
    } else if (movie is Movie) {
      log.d(() => 'movie is Movie, converting to Map');
      final Movie m = movie as Movie;
      return {
        'vod_id': m.id,
        'vod_name': m.title,
        'vod_pic': m.coverUrl,
        'vod_year': m.year,
        'url': m.url,
        // 其他字段设为默认值
        'vod_actor': '',
        'vod_director': '',
        'vod_content': '',
        'vod_blurb': '',
        'vod_remarks': '',
      };
    } else {
      log.w(() => 'movie is unknown type: ${movie.runtimeType}, returning empty Map');
      return {};
    }
  }
}

class _MovieDetailPageState extends ConsumerState<MovieDetailPage> {
  final List<Map<String, String>> _episodes = [];
  final List<GlobalKey> _episodeKeys = [];
  final FocusNode _episodesFocusNode = FocusNode();
  final ScrollController _episodesScrollController = ScrollController();
  int _focusedIndex = 0;
  final FocusNode _mainContentFocusNode = FocusNode();
  bool _isEpisodesFocused = false;
  bool _isFavorite = false;

  @override
  void initState() {
    super.initState();
    _parseEpisodes();
    _mainContentFocusNode.requestFocus();

    _episodesFocusNode.addListener(() {
      log.v(() => '剧集列表焦点变化: hasFocus=${_episodesFocusNode.hasFocus}');
      if (mounted) {
        setState(() {
          _isEpisodesFocused = _episodesFocusNode.hasFocus;
        });
      }
    });

    _episodesScrollController.addListener(_handleScroll);
    _checkFavoriteStatus();
  }

  void _checkFavoriteStatus() async {
    final movieId = widget.movieMap['vod_id']?.toString() ?? '';
    final isFav = await ref
        .read(favoritesProvider.notifier)
        .isFavorite(movieId);
    if (mounted) {
      setState(() {
        _isFavorite = isFav;
      });
    }
  }

  void _toggleFavorite() async {
    await ref.read(favoritesProvider.notifier).toggleFavorite(widget.movieMap);
    if (mounted) {
      setState(() {
        _isFavorite = !_isFavorite;
      });
    }
  }

  void _handleScroll() {
    if (_episodesScrollController.hasClients) {
      final ScrollPosition scrollPosition = _episodesScrollController.position;
      if (scrollPosition.isScrollingNotifier.value && _isEpisodesFocused) {
        // Maintain focus during scroll
        _episodesFocusNode.requestFocus();
      }
    }
  }

  @override
  void dispose() {
    _episodesFocusNode.dispose();
    _episodesScrollController.removeListener(_handleScroll);
    _episodesScrollController.dispose();
    _mainContentFocusNode.dispose();
    super.dispose();
  }

  void _parseEpisodes() {
    _episodes.clear();
    final String? playUrl = widget.movieMap['url'] as String?;
    if (playUrl != null) {
      final List<String> parts = playUrl.split('#');
      for (var part in parts) {
        final List<String> episodeParts = part.split('\$');
        if (episodeParts.length == 2) {
          _episodes.add({'title': episodeParts[0], 'url': episodeParts[1]});
        }
      }
    }
    _episodeKeys.clear();
    _episodeKeys.addAll(
      List.generate(_episodes.length, (index) => GlobalKey()),
    );
    setState(() {});
  }

  void _playEpisode(int index) {
    final List<Map<String, dynamic>>? sources =
        widget.movieMap['sources'] as List<Map<String, dynamic>>?;
    GoRouter.of(context).push(
      AppRoutes.player,
      extra: {
        'movie': widget.movieMap,
        'episodes': _episodes,
        'initialIndex': index,
        'sources': sources,
        'currentSourceIndex': 0,
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.theme;
    final ColorScheme colorScheme = theme.colorScheme;
    final TextTheme textTheme = theme.textTheme;

    return Scaffold(
      body: Focus(
        focusNode: _mainContentFocusNode,
        autofocus: true,
        onKeyEvent: (node, event) {
          if (event is KeyDownEvent) {
            if (event.logicalKey == LogicalKeyboardKey.arrowDown &&
                !_isEpisodesFocused &&
                _episodes.isNotEmpty) {
              log.v(() => '用户按键切换焦点到剧集列表');
              _episodesFocusNode.requestFocus();
              return KeyEventResult.handled;
            }
            if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
                _isEpisodesFocused) {
              log.v(() => '用户按键切换焦点到主内容');
              _mainContentFocusNode.requestFocus();
              return KeyEventResult.handled;
            }
          }
          return KeyEventResult.ignored;
        },
        child: Column(
          children: [
            // Scrollable content (header and description)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Movie header
                    Container(
                      height: 240,
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            colorScheme.surface.withAlpha((255 * 0.8).toInt()),
                            colorScheme.surface,
                          ],
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Hero(
                              tag: 'poster-${widget.movieMap['vod_id']}',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedImage(
                                  imageUrl: widget.movieMap['vod_pic'] ?? '',
                                  width: 120,
                                  height: 180,
                                  fit: BoxFit.cover,
                                  placeholder: (BuildContext ctx, String url) =>
                                      networkImagePlaceholder(ctx),
                                  errorWidget:
                                      (
                                        BuildContext ctx,
                                        String url,
                                        Object error,
                                      ) => networkImageErrorWidget(ctx),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          widget.movieMap['vod_name'] ?? '未知标题',
                                          style: textTheme.displayMedium,
                                        ),
                                      ),
                                      IconButton(
                                        icon: Icon(
                                          _isFavorite
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: _isFavorite
                                              ? Colors.red
                                              : null,
                                        ),
                                        onPressed: _toggleFavorite,
                                        iconSize: 32,
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      if (widget.movieMap['vod_year'] != null)
                                        Chip(
                                          label: Text(
                                            widget.movieMap['vod_year']!,
                                          ),
                                          visualDensity: VisualDensity.compact,
                                        ),
                                      if (widget.movieMap['type_name'] != null)
                                        Chip(
                                          label: Text(
                                            widget.movieMap['type_name']!,
                                          ),
                                          visualDensity: VisualDensity.compact,
                                        ),
                                      if (widget.movieMap['vod_remarks'] != null)
                                        Chip(
                                          label: Text(
                                            widget.movieMap['vod_remarks']!,
                                          ),
                                          visualDensity: VisualDensity.compact,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '主演: ${widget.movieMap['vod_actor'] ?? '未知'}',
                                    style: textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '导演: ${widget.movieMap['vod_director'] ?? '未知'}',
                                    style: textTheme.bodyLarge,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                    // Description with flexible height
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('剧情简介', style: textTheme.headlineMedium),
                          const SizedBox(height: 8),
                          Text(
                            widget.movieMap['vod_content'] ??
                                widget.movieMap['vod_blurb'] ??
                                '暂无简介',
                            style: textTheme.bodyLarge,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // Episodes section fixed at bottom
            if (_episodes.isNotEmpty) ...[
              Container(
                padding: const EdgeInsets.only(bottom: 16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Text('选集', style: textTheme.headlineMedium),
                    ),
                    const SizedBox(height: 12),
                    SizedBox(
                      height: 56,
                      child: FocusTraversalGroup(
                        policy: WidgetOrderTraversalPolicy(),
                        child: Focus(
                          focusNode: _episodesFocusNode,
                          autofocus: false,
                          onKeyEvent: (node, event) {
                            if (event is KeyDownEvent) {
                              if (event.logicalKey ==
                                  LogicalKeyboardKey.arrowLeft) {
                                if (_focusedIndex > 0) {
                                  log.v(() => '用户按键选择上一集: $_focusedIndex -> ${_focusedIndex - 1}');
                                  setState(() {
                                    _focusedIndex--;
                                  });
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    final BuildContext? context =
                                        _episodeKeys[_focusedIndex]
                                            .currentContext;
                                    if (context != null) {
                                      Scrollable.ensureVisible(
                                        context,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  });
                                  return KeyEventResult.handled;
                                }
                              } else if (event.logicalKey ==
                                  LogicalKeyboardKey.arrowRight) {
                                if (_focusedIndex < _episodes.length - 1) {
                                  log.v(() => '用户按键选择下一集: $_focusedIndex -> ${_focusedIndex + 1}');
                                  setState(() {
                                    _focusedIndex++;
                                  });
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    final BuildContext? context =
                                        _episodeKeys[_focusedIndex]
                                            .currentContext;
                                    if (context != null) {
                                      Scrollable.ensureVisible(
                                        context,
                                        duration: const Duration(
                                          milliseconds: 300,
                                        ),
                                        curve: Curves.easeInOut,
                                      );
                                    }
                                  });
                                  return KeyEventResult.handled;
                                }
                              } else if (event.logicalKey ==
                                      LogicalKeyboardKey.select ||
                                  event.logicalKey ==
                                      LogicalKeyboardKey.enter) {
                                _playEpisode(_focusedIndex);
                                return KeyEventResult.handled;
                              } else if (event.logicalKey ==
                                  LogicalKeyboardKey.arrowUp) {
                                _mainContentFocusNode.requestFocus();
                                return KeyEventResult.handled;
                              }
                            }
                            return KeyEventResult.ignored;
                          },
                          child: ScrollConfiguration(
                            behavior: ScrollBehavior().copyWith(
                              scrollbars: true,
                              overscroll: false,
                              physics: const BouncingScrollPhysics(),
                            ),
                            child: ListView.builder(
                              controller: _episodesScrollController,
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 16,
                              ),
                              itemCount: _episodes.length,
                              itemBuilder: (context, index) {
                                final bool isFocused =
                                    _isEpisodesFocused &&
                                    _focusedIndex == index;
                                return Padding(
                                  padding: const EdgeInsets.only(right: 12.0),
                                  child: Focus(
                                    key: _episodeKeys[index],
                                    onFocusChange: (hasFocus) {
                                      if (hasFocus) {
                                        setState(() {
                                          _focusedIndex = index;
                                        });
                                      }
                                    },
                                    child: FilledButton.tonal(
                                      style: FilledButton.styleFrom(
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 16,
                                          vertical: 8,
                                        ),
                                        backgroundColor: isFocused
                                            ? colorScheme.primaryContainer
                                            : colorScheme
                                                  .surfaceContainerHighest,
                                        foregroundColor: isFocused
                                            ? colorScheme.onPrimaryContainer
                                            : colorScheme.onSurfaceVariant,
                                        elevation: isFocused ? 4 : 0,
                                        side: BorderSide(
                                          color: isFocused
                                              ? colorScheme.primary
                                              : Colors.transparent,
                                          width: isFocused ? 2 : 0,
                                        ),
                                      ),
                                      onPressed: () => _playEpisode(index),
                                      child: Text(
                                        _episodes[index]['title']!,
                                        style: textTheme.bodyLarge!.copyWith(
                                          fontWeight: isFocused
                                              ? FontWeight.bold
                                              : FontWeight.normal,
                                          fontSize: isFocused ? 18 : 16,
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
