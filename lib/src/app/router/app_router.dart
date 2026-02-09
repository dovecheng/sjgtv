import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:sjgtv/src/app/router/app_routes.dart';
import 'package:sjgtv/src/app/router/page_transitions.dart';
import 'package:sjgtv/src/movie/page/category_page.dart';
import 'package:sjgtv/src/movie/page/search_page.dart';
import 'package:sjgtv/src/movie/page/movie_detail_page.dart';
import 'package:sjgtv/src/movie/page/full_screen_player_page.dart';
import 'package:sjgtv/src/source/page/source_manage_page.dart';
import 'package:sjgtv/src/source/page/source_form_page.dart';
import 'package:sjgtv/src/source/model/source_model.dart';
import 'package:sjgtv/core/debug/router_observer.dart';

/// 应用路由配置
///
/// 使用 go_router 进行声明式路由管理
class AppRouter {
  AppRouter._();

  static GoRouter get router => GoRouter(
    initialLocation: AppRoutes.home,
    debugLogDiagnostics: true,
    observers: [RouterObserver()],
    routes: [
      // 首页
      GoRoute(
        path: AppRoutes.home,
        name: 'home',
        pageBuilder: (context, state) => const MaterialPage<void>(
          key: ValueKey('home'),
          child: MovieHomePage(),
        ),
      ),

      // 搜索页面
      GoRoute(
        path: AppRoutes.search,
        name: 'search',
        pageBuilder: (context, state) {
          final String? initialQuery = state.uri.queryParameters['q'];
          return TVPageTransition(
            key: state.pageKey,
            child: SearchPage(initialQuery: initialQuery ?? ''),
          );
        },
      ),

      // 电影详情页面
      GoRoute(
        path: AppRoutes.movieDetail,
        name: 'movieDetail',
        pageBuilder: (context, state) {
          final Map<String, dynamic> movie =
              state.extra as Map<String, dynamic>? ?? {};
          return TVPageTransition(
            key: state.pageKey,
            child: MovieDetailPage(movie: movie),
          );
        },
      ),

      // 播放器页面
      GoRoute(
        path: AppRoutes.player,
        name: 'player',
        pageBuilder: (context, state) {
          final Map<String, dynamic> extra =
              state.extra as Map<String, dynamic>? ?? {};
          final Map<String, dynamic> movie =
              extra['movie'] as Map<String, dynamic>? ?? {};
          final int initialIndex = extra['initialIndex'] as int? ?? 0;
          final List<Map<String, String>> episodes =
              extra['episodes'] as List<Map<String, String>>? ?? [];
          final List<Map<String, dynamic>>? sources =
              extra['sources'] as List<Map<String, dynamic>>?;
          final int currentSourceIndex =
              extra['currentSourceIndex'] as int? ?? 0;
          return PlayerPageTransition(
            key: state.pageKey,
            child: FullScreenPlayerPage(
              movie: movie,
              episodes: episodes,
              initialIndex: initialIndex,
              sources: sources,
              currentSourceIndex: currentSourceIndex,
            ),
          );
        },
      ),

      // 源管理页面
      GoRoute(
        path: AppRoutes.sourceManage,
        name: 'sourceManage',
        pageBuilder: (context, state) => TVPageTransition(
          key: state.pageKey,
          child: const SourceManagePage(),
        ),
        routes: [
          // 源表单页面（添加/编辑）
          GoRoute(
            path: 'form',
            name: 'sourceForm',
            pageBuilder: (context, state) {
              final SourceModel? sourceToEdit = state.extra as SourceModel?;
              return ScalePageTransition(
                key: state.pageKey,
                child: SourceFormPage(sourceToEdit: sourceToEdit),
              );
            },
          ),
        ],
      ),

      // 设置页面（预留）
      GoRoute(
        path: AppRoutes.settings,
        name: 'settings',
        pageBuilder: (context, state) => TVPageTransition(
          key: state.pageKey,
          child: Scaffold(
            appBar: AppBar(title: const Text('设置')),
            body: const Center(child: Text('设置功能开发中')),
          ),
        ),
      ),
    ],
  );
}

/// 路由扩展方法
extension AppRouterContext on BuildContext {
  /// 导航到搜索页面
  void goToSearch([String? query]) {
    String location = AppRoutes.search;
    if (query != null && query.isNotEmpty) {
      location += '?q=$query';
    }
    go(location);
  }

  /// 导航到电影详情页面
  void goToMovieDetail(Map<String, dynamic> movie) {
    go(AppRoutes.movieDetail, extra: movie);
  }

  /// 导航到播放器页面
  void goToPlayer(String url, {String? title}) {
    String location = AppRoutes.player;
    final Map<String, String> queryParams = {'url': url};
    if (title != null) {
      queryParams['title'] = title;
    }
    location += '?${Uri(queryParameters: queryParams).query}';
    go(location);
  }

  /// 导航到源管理页面
  void goToSourceManage() {
    go(AppRoutes.sourceManage);
  }

  /// 导航到源表单页面
  void goToSourceForm([Map<String, dynamic>? source]) {
    final String location = '${AppRoutes.sourceManage}/form';
    go(location, extra: source);
  }

  /// 返回上一页
  void goBack() {
    pop();
  }
}
