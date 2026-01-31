import 'package:flutter/material.dart';
import 'package:base/app.dart';
import 'package:base/cache.dart';
import 'package:flutter/services.dart';
import 'package:sjgtv/src/page/player/full_screen_player_page.dart';
import 'package:sjgtv/src/widget/network_image_placeholders.dart';

/// 电影详情页
///
/// 功能：
/// - 显示电影海报、标题、年份、类型、主演、导演
/// - 显示剧情简介
/// - 解析播放地址并显示选集列表
/// - 支持 TV 遥控器导航（上下切换区域、左右切换选集）
/// - 点击选集跳转到全屏播放器
class MovieDetailPage extends StatefulWidget {
  final dynamic movie;

  const MovieDetailPage({super.key, required this.movie});

  @override
  State<MovieDetailPage> createState() => _MovieDetailPageState();
}

class _MovieDetailPageState extends State<MovieDetailPage> {
  final List<Map<String, String>> _episodes = [];
  final List<GlobalKey> _episodeKeys = [];
  final FocusNode _episodesFocusNode = FocusNode();
  final ScrollController _episodesScrollController = ScrollController();
  int _focusedIndex = 0;
  final FocusNode _mainContentFocusNode = FocusNode();
  bool _isEpisodesFocused = false;

  @override
  void initState() {
    super.initState();
    _parseEpisodes();
    _mainContentFocusNode.requestFocus();

    _episodesFocusNode.addListener(() {
      if (mounted) {
        setState(() {
          _isEpisodesFocused = _episodesFocusNode.hasFocus;
        });
      }
    });

    _episodesScrollController.addListener(_handleScroll);
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
    final String? playUrl = widget.movie['vod_play_url'] as String?;
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
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => FullScreenPlayerPage(
          movie: widget.movie,
          episodes: _episodes,
          initialIndex: index,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = context.themeData;
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
              _episodesFocusNode.requestFocus();
              return KeyEventResult.handled;
            }
            if (event.logicalKey == LogicalKeyboardKey.arrowUp &&
                _isEpisodesFocused) {
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
                              tag: 'poster-${widget.movie['vod_id']}',
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(12),
                                child: CachedImage(
                                  imageUrl: widget.movie['vod_pic'] ?? '',
                                  width: 120,
                                  height: 180,
                                  fit: BoxFit.cover,
                                  placeholder: (BuildContext ctx, String url) =>
                                      networkImagePlaceholder(ctx),
                                  errorWidget: (BuildContext ctx,
                                          String url, Object error) =>
                                      networkImageErrorWidget(ctx),
                                ),
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    widget.movie['vod_name'] ?? '未知标题',
                                    style: textTheme.displayMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    runSpacing: 4,
                                    children: [
                                      if (widget.movie['vod_year'] != null)
                                        Chip(
                                          label: Text(
                                            widget.movie['vod_year']!,
                                          ),
                                          visualDensity: VisualDensity.compact,
                                        ),
                                      if (widget.movie['type_name'] != null)
                                        Chip(
                                          label: Text(
                                            widget.movie['type_name']!,
                                          ),
                                          visualDensity: VisualDensity.compact,
                                        ),
                                      if (widget.movie['vod_remarks'] != null)
                                        Chip(
                                          label: Text(
                                            widget.movie['vod_remarks']!,
                                          ),
                                          visualDensity: VisualDensity.compact,
                                        ),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Text(
                                    '主演: ${widget.movie['vod_actor'] ?? '未知'}',
                                    style: textTheme.bodyLarge,
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    '导演: ${widget.movie['vod_director'] ?? '未知'}',
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
                          Text(
                            '剧情简介',
                            style: textTheme.headlineMedium,
                          ),
                          const SizedBox(height: 8),
                          Text(
                            widget.movie['vod_content'] ??
                                widget.movie['vod_blurb'] ??
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
                      child: Text(
                        '选集',
                        style: textTheme.headlineMedium,
                      ),
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
                                  setState(() {
                                    _focusedIndex--;
                                  });
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    final BuildContext? context = _episodeKeys[_focusedIndex]
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
                                  setState(() {
                                    _focusedIndex++;
                                  });
                                  WidgetsBinding.instance.addPostFrameCallback((
                                    _,
                                  ) {
                                    final BuildContext? context = _episodeKeys[_focusedIndex]
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
                                        style: textTheme
                                            .bodyLarge!
                                            .copyWith(
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
