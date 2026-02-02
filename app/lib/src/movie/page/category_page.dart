import 'dart:io';

import 'package:base/api.dart';
import 'package:base/app.dart';
import 'package:base/extension.dart';
import 'package:base/log.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sjgtv/src/movie/model/movie_model.dart';
import 'package:sjgtv/src/tag/model/tag_model.dart';
import 'package:sjgtv/src/tag/provider/tags_provider.dart';
import 'package:sjgtv/src/movie/page/search_page.dart';
import 'package:sjgtv/src/app/widget/update_checker.dart';
import 'package:sjgtv/src/source/page/source_manage_page.dart';
import 'package:sjgtv/src/movie/widget/focusable_movie_card.dart';

final Log _log = Log('MovieHomePage');

/// 电影首页（分类浏览）
///
/// 功能：
/// - 启动时检查应用更新
/// - 从本地 shelf 服务获取标签列表作为分类 Tab
/// - 从豆瓣 API 获取对应分类的电影列表
/// - 支持 TV 遥控器导航（Tab 切换、电影卡片聚焦）
/// - 支持下拉刷新和滚动加载更多
/// - 显示二维码供手机端管理数据源
class MovieHomePage extends ConsumerStatefulWidget {
  const MovieHomePage({super.key});

  @override
  ConsumerState<MovieHomePage> createState() => _MovieHomePageState();
}

class _MovieHomePageState extends ConsumerState<MovieHomePage> {
  Dio get _dio => ref.read(apiClientProvider);
  int _selectedTab = 0;
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _hasMore = true;
  List<String> _tabs = ['加载中...'];
  final Map<String, List<MovieModel>> _moviesByTag = {};
  final Set<String> _loadedTags = {};
  final Map<String, int> _currentPageByTag = {};
  static const int _moviesPerPage = 20;
  static const int _gridCrossAxisCount = 5;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _refreshFocusNode = FocusNode();
  final List<FocusNode> _cardFocusNodes = [];
  final List<GlobalKey> _cardKeys = [];
  DateTime? _lastLoadMoreTime;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialData();
    _checkForUpdates();
  }

  Future<void> _checkForUpdates() async {
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;
    await AppUpdater.checkForUpdate(context);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshFocusNode.dispose();
    for (final FocusNode node in _cardFocusNodes) {
      node.dispose();
    }
    _cardFocusNodes.clear();
    super.dispose();
  }

  void _ensureCardFocusNodes(int count) {
    while (_cardFocusNodes.length < count) {
      _cardFocusNodes.add(FocusNode());
    }
    if (_cardFocusNodes.length > count) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (!mounted) return;
        for (int i = count; i < _cardFocusNodes.length; i++) {
          _cardFocusNodes[i].dispose();
        }
        _cardFocusNodes.removeRange(count, _cardFocusNodes.length);
      });
    }
  }

  void _ensureCardKeys(int count) {
    while (_cardKeys.length < count) {
      _cardKeys.add(GlobalKey());
    }
  }

  void _onScroll() {
    if (!_scrollController.hasClients || !mounted) return;
    final ScrollPosition position = _scrollController.position;
    final double maxScroll = position.maxScrollExtent;
    final double currentScroll = position.pixels;

    if (currentScroll >= maxScroll - 1.0 &&
        _hasMore &&
        !_isLoading &&
        _tabs.isNotEmpty &&
        _selectedTab < _tabs.length) {
      final DateTime now = DateTime.now();
      if (_lastLoadMoreTime == null ||
          now.difference(_lastLoadMoreTime!) > Duration(milliseconds: 100)) {
        _lastLoadMoreTime = now;
        _fetchMovies(_tabs[_selectedTab], loadMore: true);
      }
    }
  }

  Future<void> _loadInitialData() async {
    if (!mounted) return;
    setState(() => _isLoading = true);
    await _fetchTags();
    if (!mounted) return;
    if (_tabs.isNotEmpty && _tabs[0] != '加载中...') {
      await _fetchMovies(_tabs[_selectedTab]);
    }
    if (!mounted) return;
    setState(() => _isLoading = false);
  }

  Future<void> _fetchTags() async {
    try {
      final List<TagModel> tags = await ref.read(tagsStorageProvider.future);
      if (!mounted) return;
      setState(() {
        _tabs = tags.map((TagModel tag) => tag.name).toList();
        for (String tag in _tabs) {
          _currentPageByTag[tag] = 0;
        }
      });
    } catch (e) {
      _log.e(() => '获取标签失败', e);
      if (!mounted) return;
      setState(() {
        _tabs = ['获取标签失败'];
      });
    }
  }

  Future<void> _fetchMovies(String tag, {bool loadMore = false}) async {
    if (tag == '加载中...' || tag == '获取标签失败') return;
    if (!loadMore && _loadedTags.contains(tag)) {
      return;
    }

    try {
      setState(() => loadMore ? _isRefreshing = true : _isLoading = true);

      final int currentPage = loadMore ? (_currentPageByTag[tag] ?? 0) : 0;
      final int startIndex = currentPage * _moviesPerPage;

      final Response<dynamic> response = await _dio.get<dynamic>(
        'https://movie.douban.com/j/search_subjects',
        queryParameters: <String, String>{
          'type': 'movie',
          'tag': tag,
          'sort': 'recommend',
          'page_limit': _moviesPerPage.toString(),
          'page_start': startIndex.toString(),
        },
        options: Options(headers: <String, String>{'Content-Type': ''}),
      );

      if (!mounted) return;

      if (response.statusCode == 200) {
        final ApiResultModel<Map<String, dynamic>> result =
            ApiResultModel.fromJson(response.data);
        final List<dynamic> subjects = result.data?['subjects'] ?? [];
        log.d(() => 'subjects: $subjects');
        final List<MovieModel> movies = subjects
            .map(
              (dynamic s) =>
                  MovieModel.fromJson(Map<String, dynamic>.from(s as Map)),
            )
            .toList();

        setState(() {
          if (loadMore) {
            _moviesByTag[tag] = [..._moviesByTag[tag] ?? [], ...movies];
          } else {
            _moviesByTag[tag] = movies;
            _loadedTags.add(tag);
          }
          _currentPageByTag[tag] = currentPage + 1;
          _hasMore = movies.length >= _moviesPerPage;
        });
      }
    } catch (e) {
      _log.e(() => '获取电影失败', e);
      if (mounted) setState(() => _hasMore = false);
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
          _isRefreshing = false;
        });
      }
    }
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;
    if (!mounted) return;
    setState(() {
      _isRefreshing = true;
      _currentPageByTag[_tabs[_selectedTab]] = 0;
      _loadedTags.remove(_tabs[_selectedTab]);
    });

    await _fetchMovies(_tabs[_selectedTab]);

    if (!mounted) return;
    setState(() {
      _isRefreshing = false;
    });
  }

  List<MovieModel> get _currentMovies =>
      _moviesByTag[_tabs[_selectedTab]] ?? [];

  Future<String> _getLocalIp() async {
    try {
      final List<NetworkInterface> interfaces = await NetworkInterface.list();
      for (var interface in interfaces) {
        for (var addr in interface.addresses) {
          if (!addr.isLoopback && addr.type == InternetAddressType.IPv4) {
            return addr.address;
          }
        }
      }
      return '127.0.0.1';
    } catch (e) {
      _log.e(() => '获取IP失败', e);
      return '127.0.0.1';
    }
  }

  Future<void> _showQRCodeDialog() async {
    final String ip = await _getLocalIp();
    final String url = 'http://$ip:8023';

    if (!mounted) return;

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        backgroundColor: Colors.black,
        title: Text(
          '扫描二维码管理',
          style: TextStyle(color: Colors.white),
          textAlign: TextAlign.center,
        ),
        content: SizedBox(
          width: 300,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              QrImageView(
                data: url,
                version: QrVersions.auto,
                size: 200.0,
                backgroundColor: Colors.white,
              ),
              SizedBox(height: 16),
              Text(url, style: TextStyle(color: Colors.white)),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('关闭', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  Widget _buildAppBar() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, right: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [
          IconButton(
            icon: const Icon(Icons.search, size: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const SearchPage(),
                ),
              );
            },
            focusColor: Colors.red,
          ),
          const SizedBox(width: 10),
          IconButton(
            icon: const Icon(Icons.source, size: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute<void>(
                  builder: (BuildContext context) => const SourceManagePage(),
                ),
              );
            },
            focusColor: Colors.red,
          ),
          if ($platform.isMobileNative &&
              context.mediaQuery.deviceType == DeviceType.tv) ...[
            const SizedBox(width: 10),
            IconButton(
              icon: const Icon(Icons.settings, size: 20),
              onPressed: _showQRCodeDialog,
              focusColor: Colors.red,
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 70,
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 30),
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Focus(
              autofocus: index == _selectedTab,
              onFocusChange: (hasFocus) {
                if (hasFocus) {
                  setState(() {
                    _selectedTab = index;
                    _hasMore = true;
                  });
                  _fetchMovies(_tabs[index]);
                }
              },
              child: Builder(
                builder: (context) {
                  final bool isFocused = Focus.of(context).hasFocus;
                  return AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 12,
                    ),
                    constraints: const BoxConstraints(minWidth: 100),
                    decoration: BoxDecoration(
                      color: _selectedTab == index
                          ? Colors.red
                          : context.theme.colorScheme.surfaceContainerLow,
                      borderRadius: BorderRadius.circular(35),
                      border: isFocused
                          ? Border.all(color: Colors.white, width: 2)
                          : null,
                    ),
                    child: SizedBox(
                      height: double.infinity,
                      child: Center(
                        child: Text(
                          _tabs[index],
                          style: TextStyle(
                            color: _selectedTab == index
                                ? Colors.white
                                : Colors.grey,
                            fontSize: 20,
                            height: 1.0,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.visible,
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          );
        },
      ),
    );
  }

  void _scrollToCard(int targetIndex) {
    if (targetIndex < 0 || targetIndex >= _cardKeys.length || !mounted) return;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      final BuildContext? ctx = _cardKeys[targetIndex].currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  Widget _buildMovieGrid() {
    final int itemCount = _currentMovies.length;
    _ensureCardFocusNodes(itemCount);
    _ensureCardKeys(itemCount);
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: GridView.builder(
        controller: _scrollController,
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: _gridCrossAxisCount,
          childAspectRatio: 0.65,
          mainAxisSpacing: 30,
          crossAxisSpacing: 30,
        ),
        itemCount: itemCount,
        itemBuilder: (BuildContext context, int index) {
          return FocusableMovieCard(
            key: _cardKeys[index],
            movie: _currentMovies[index],
            focusNode: index < _cardFocusNodes.length
                ? _cardFocusNodes[index]
                : null,
            gridIndex: index,
            crossAxisCount: _gridCrossAxisCount,
            itemCount: itemCount,
            onMoveFocus: (int targetIndex) {
              if (targetIndex >= 0 &&
                  targetIndex < _cardFocusNodes.length &&
                  mounted) {
                _cardFocusNodes[targetIndex].requestFocus();
                _scrollToCard(targetIndex);
              }
            },
          );
        },
        padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Column(
          children: [
            _buildAppBar(),
            _buildTabBar(),
            if (_isLoading)
              const Expanded(child: Center(child: CircularProgressIndicator()))
            else if (_tabs.isNotEmpty && _tabs[0] == '获取标签失败')
              Expanded(
                child: Center(
                  child: Text(
                    '无法加载标签，请检查网络连接',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              )
            else if (_tabs.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    '暂无标签',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              )
            else if (_currentMovies.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    '没有找到电影数据',
                    style: const TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              )
            else
              Expanded(
                child: Focus(
                  focusNode: _refreshFocusNode,
                  onKeyEvent: (FocusNode node, KeyEvent event) {
                    if (event is KeyDownEvent &&
                        event.logicalKey == LogicalKeyboardKey.pageUp) {
                      _handleRefresh();
                      return KeyEventResult.handled;
                    }
                    return KeyEventResult.ignored;
                  },
                  child: _buildMovieGrid(),
                ),
              ),
          ],
        ),
      ),
    );
  }
}
