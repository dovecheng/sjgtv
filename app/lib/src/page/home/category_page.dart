import 'dart:io';

import 'package:base/api.dart';
import 'package:base/log.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:sjgtv/src/api/service/api_service.dart';
import 'package:sjgtv/src/app/provider/api_service_provider.dart';
import 'package:sjgtv/src/model/movie.dart';
import 'package:sjgtv/src/model/tag.dart';
import 'package:sjgtv/src/page/search/search_page.dart';
import 'package:sjgtv/src/widget/focusable_movie_card.dart';

final Log _log = Log('MovieHomePage');

/// 电影首页（分类浏览）
///
/// 功能：
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
  ApiService get _apiService => ref.read(apiServiceProvider);
  final Dio _dio = Dio(); // 保留用于外部 API（豆瓣）
  int _selectedTab = 0;
  bool _isLoading = false;
  bool _isRefreshing = false;
  bool _hasMore = true;
  List<String> _tabs = ['加载中...'];
  final Map<String, List<Movie>> _moviesByTag = {};
  final Set<String> _loadedTags = {};
  final Map<String, int> _currentPageByTag = {};
  static const int _moviesPerPage = 20;
  final ScrollController _scrollController = ScrollController();
  final FocusNode _refreshFocusNode = FocusNode();
  DateTime? _lastLoadMoreTime;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _loadInitialData();
  }

  @override
  void dispose() {
    _scrollController.dispose();
    _refreshFocusNode.dispose();
    super.dispose();
  }

  void _onScroll() {
    final ScrollPosition position = _scrollController.position;
    final double maxScroll = position.maxScrollExtent;
    final double currentScroll = position.pixels;

    // Use a small epsilon value (1.0) to account for floating-point precision
    // Also add a debounce to prevent rapid successive calls

    if (currentScroll >= maxScroll - 1.0 && _hasMore && !_isLoading) {
      final DateTime now = DateTime.now();
      if (_lastLoadMoreTime == null ||
          now.difference(_lastLoadMoreTime!) > Duration(milliseconds: 100)) {
        _lastLoadMoreTime = now;
        _fetchMovies(_tabs[_selectedTab], loadMore: true);
      }
    }
  }

  Future<void> _loadInitialData() async {
    setState(() => _isLoading = true);
    await _fetchTags();
    if (_tabs.isNotEmpty && _tabs[0] != '加载中...') {
      await _fetchMovies(_tabs[_selectedTab]);
    }
    setState(() => _isLoading = false);
  }

  Future<void> _fetchTags() async {
    try {
      final ApiListResultModel<Tag> result = await _apiService.getTags();

      if (result.isSuccess && result.data != null) {
        setState(() {
          _tabs = result.data!.map((tag) => tag.name).toList();
          for (String tag in _tabs) {
            _currentPageByTag[tag] = 0;
          }
        });
      } else {
        _log.e(() => '获取标签失败: ${result.message}');
        setState(() {
          _tabs = ['获取标签失败'];
        });
      }
    } catch (e) {
      _log.e(() => '获取标签失败', e);
      setState(() {
        _tabs = ['获取标签失败'];
      });
    }
  }

  Future<void> _fetchMovies(String tag, {bool loadMore = false}) async {
    if (!loadMore && _loadedTags.contains(tag)) {
      return;
    }

    try {
      setState(() => loadMore ? _isRefreshing = true : _isLoading = true);

      final int currentPage = loadMore ? (_currentPageByTag[tag] ?? 0) : 0;
      final int startIndex = currentPage * _moviesPerPage;

      final Response<dynamic> response = await _dio.get<dynamic>(
        'https://movie.douban.com/j/search_subjects',
        queryParameters: {
          'type': 'movie',
          'tag': tag,
          'sort': 'recommend',
          'page_limit': _moviesPerPage.toString(),
          'page_start': startIndex.toString(),
        },
      );

      if (response.statusCode == 200) {
        final List<dynamic> subjects = response.data['subjects'] ?? [];
        final List<Movie> movies = subjects.map((subject) {
          return Movie(
            id: subject['id'],
            title: subject['title'],
            year: _extractYearFromTitle(subject['title']),
            rating: double.tryParse(subject['rate'] ?? '0') ?? 0,
            coverUrl: subject['cover'],
            playable: subject['playable'] ?? false,
            isNew: subject['is_new'] ?? false,
            url:
                "https://img3.doubanio.com/view/photo/s_ratio_poster/public/p2897743122.jpg",
          );
        }).toList();

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
      setState(() => _hasMore = false);
    } finally {
      setState(() {
        _isLoading = false;
        _isRefreshing = false;
      });
    }
  }

  Future<void> _handleRefresh() async {
    if (_isRefreshing) return;

    setState(() {
      _isRefreshing = true;
      _currentPageByTag[_tabs[_selectedTab]] = 0;
      _loadedTags.remove(_tabs[_selectedTab]);
    });

    await _fetchMovies(_tabs[_selectedTab]);

    setState(() {
      _isRefreshing = false;
    });
  }

  int _extractYearFromTitle(String title) {
    try {
      final RegExpMatch? match = RegExp(r'$(\d{4})$').firstMatch(title);
      if (match != null) {
        return int.parse(match.group(1)!);
      }
      return DateTime.now().year;
    } catch (e) {
      return DateTime.now().year;
    }
  }

  List<Movie> get _currentMovies => _moviesByTag[_tabs[_selectedTab]] ?? [];

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
            icon: Icon(Icons.search, size: 20),
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => SearchPage()),
              );
            },
            focusColor: Colors.red,
          ),
          SizedBox(width: 10),
          IconButton(
            icon: Icon(Icons.settings, size: 20),
            onPressed: _showQRCodeDialog,
            focusColor: Colors.red,
          ),
        ],
      ),
    );
  }

  Widget _buildTabBar() {
    return Container(
      height: 70,
      padding: EdgeInsets.symmetric(vertical: 12),
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        padding: EdgeInsets.symmetric(horizontal: 30),
        itemCount: _tabs.length,
        itemBuilder: (context, index) {
          return Padding(
            padding: EdgeInsets.symmetric(horizontal: 10),
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
                    duration: Duration(milliseconds: 200),
                    padding: EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                    constraints: BoxConstraints(minWidth: 100),
                    decoration: BoxDecoration(
                      color: _selectedTab == index
                          ? Colors.red
                          : Color(0xFF333333),
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

  Widget _buildMovieGrid() {
    return RefreshIndicator(
      onRefresh: _handleRefresh,
      child: GridView.builder(
        controller: _scrollController,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 5,
          childAspectRatio: 0.65,
          mainAxisSpacing: 30,
          crossAxisSpacing: 30,
        ),
        itemCount: _currentMovies.length,
        itemBuilder: (context, index) {
          return FocusableMovieCard(movie: _currentMovies[index]);
        },
        padding: EdgeInsets.only(left: 20, top: 20, right: 20),
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
              Expanded(child: Center(child: CircularProgressIndicator()))
            else if (_tabs[0] == '获取标签失败')
              Expanded(
                child: Center(
                  child: Text(
                    '无法加载标签，请检查网络连接',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              )
            else if (_currentMovies.isEmpty)
              Expanded(
                child: Center(
                  child: Text(
                    '没有找到电影数据',
                    style: TextStyle(color: Colors.white, fontSize: 24),
                  ),
                ),
              )
            else
              Expanded(
                child: Focus(
                  focusNode: _refreshFocusNode,
                  onKeyEvent: (node, event) {
                    if (event is KeyDownEvent &&
                        (event.logicalKey == LogicalKeyboardKey.arrowUp ||
                            event.logicalKey == LogicalKeyboardKey.pageUp)) {
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

