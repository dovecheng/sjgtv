import 'package:riverpod/riverpod.dart';

import '../../domain/repositories/movie_repository.dart';
import '../../domain/repositories/source_repository.dart';
import '../../domain/repositories/proxy_repository.dart';
import '../../domain/repositories/tag_repository.dart';
import '../../domain/repositories/watch_history_repository.dart';
import '../../domain/repositories/favorite_repository.dart';
import '../../domain/usecases/add_source_usecase.dart';
import '../../domain/usecases/get_all_sources_usecase.dart';
import '../../domain/usecases/get_movies_by_category_usecase.dart';
import '../../domain/usecases/search_movies_usecase.dart';
import '../../domain/usecases/save_watch_history_usecase.dart';
import '../../domain/usecases/get_all_watch_histories_usecase.dart';
import '../../domain/usecases/delete_watch_history_usecase.dart';
import '../../domain/usecases/add_favorite_usecase.dart';
import '../../domain/usecases/get_all_favorites_usecase.dart';
import '../../domain/usecases/delete_favorite_usecase.dart';
import '../../domain/usecases/is_favorite_usecase.dart';
import '../../domain/usecases/unfavorite_usecase.dart';
import '../../data/datasources/local_datasource.dart';
import '../../data/datasources/local_datasource_impl.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../data/repositories/source_repository_impl.dart';
import '../../data/repositories/proxy_repository_impl.dart';
import '../../data/repositories/tag_repository_impl.dart';
import '../../data/repositories/watch_history_repository_impl.dart';
import '../../data/repositories/favorite_repository_impl.dart';

/// 本地数据源 Provider
final localDataSourceProvider = Provider<LocalDataSource>((ref) {
  return LocalDataSourceImpl();
});

/// 代理仓库 Provider
final proxyRepositoryProvider = Provider<ProxyRepository>((ref) {
  return ProxyRepositoryImpl(
    localDataSource: ref.watch(localDataSourceProvider),
  );
});

/// 标签仓库 Provider
final tagRepositoryProvider = Provider<TagRepository>((ref) {
  return TagRepositoryImpl(
    localDataSource: ref.watch(localDataSourceProvider),
  );
});

/// 视频源仓库 Provider
final sourceRepositoryProvider = Provider<SourceRepository>((ref) {
  return SourceRepositoryImpl(
    localDataSource: ref.watch(localDataSourceProvider),
  );
});

/// 电影仓库 Provider
final movieRepositoryProvider = Provider<MovieRepository>((ref) {
  return MovieRepositoryImpl(
    sourceRepository: ref.watch(sourceRepositoryProvider),
    proxyRepository: ref.watch(proxyRepositoryProvider),
  );
});

/// 获取所有视频源 Use Case Provider
final getAllSourcesUseCaseProvider = Provider<GetAllSourcesUseCase>((ref) {
  return GetAllSourcesUseCase(
    ref.watch(sourceRepositoryProvider),
  );
});

/// 添加视频源 Use Case Provider
final addSourceUseCaseProvider = Provider<AddSourceUseCase>((ref) {
  return AddSourceUseCase(
    ref.watch(sourceRepositoryProvider),
  );
});

/// 搜索电影 Use Case Provider
final searchMoviesUseCaseProvider = Provider<SearchMoviesUseCase>((ref) {
  return SearchMoviesUseCase(
    ref.watch(movieRepositoryProvider),
  );
});

/// 获取分类电影 Use Case Provider
final getMoviesByCategoryUseCaseProvider = Provider<GetMoviesByCategoryUseCase>((ref) {
  return GetMoviesByCategoryUseCase(
    ref.watch(movieRepositoryProvider),
  );
});

/// 观看历史仓库 Provider
final watchHistoryRepositoryProvider = Provider<WatchHistoryRepository>((ref) {
  return WatchHistoryRepositoryImpl(
    localDataSource: ref.watch(localDataSourceProvider),
  );
});

/// 获取所有观看历史 Use Case Provider
final getAllWatchHistoriesUseCaseProvider = Provider<GetAllWatchHistoriesUseCase>((ref) {
  return GetAllWatchHistoriesUseCase(
    ref.watch(watchHistoryRepositoryProvider),
  );
});

/// 保存观看历史 Use Case Provider
final saveWatchHistoryUseCaseProvider = Provider<SaveWatchHistoryUseCase>((ref) {
  return SaveWatchHistoryUseCase(
    ref.watch(watchHistoryRepositoryProvider),
  );
});

/// 删除观看历史 Use Case Provider
final deleteWatchHistoryUseCaseProvider = Provider<DeleteWatchHistoryUseCase>((ref) {
  return DeleteWatchHistoryUseCase(
    ref.watch(watchHistoryRepositoryProvider),
  );
});

/// 收藏仓库 Provider
final favoriteRepositoryProvider = Provider<FavoriteRepository>((ref) {
  return FavoriteRepositoryImpl(
    localDataSource: ref.watch(localDataSourceProvider),
  );
});

/// 添加收藏 Use Case Provider
final addFavoriteUseCaseProvider = Provider<AddFavoriteUseCase>((ref) {
  return AddFavoriteUseCase(
    ref.watch(favoriteRepositoryProvider),
  );
});

/// 获取所有收藏 Use Case Provider
final getAllFavoritesUseCaseProvider = Provider<GetAllFavoritesUseCase>((ref) {
  return GetAllFavoritesUseCase(
    ref.watch(favoriteRepositoryProvider),
  );
});

/// 删除收藏 Use Case Provider
final deleteFavoriteUseCaseProvider = Provider<DeleteFavoriteUseCase>((ref) {
  return DeleteFavoriteUseCase(
    ref.watch(favoriteRepositoryProvider),
  );
});

/// 检查是否已收藏 Use Case Provider
final isFavoriteUseCaseProvider = Provider<IsFavoriteUseCase>((ref) {
  return IsFavoriteUseCase(
    ref.watch(favoriteRepositoryProvider),
  );
});

/// 取消收藏 Use Case Provider
final unfavoriteUseCaseProvider = Provider<UnfavoriteUseCase>((ref) {
  return UnfavoriteUseCase(
    ref.watch(favoriteRepositoryProvider),
  );
});