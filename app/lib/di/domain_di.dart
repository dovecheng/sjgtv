import 'package:riverpod/riverpod.dart';

import '../../domain/repositories/movie_repository.dart';
import '../../domain/repositories/source_repository.dart';
import '../../domain/repositories/proxy_repository.dart';
import '../../domain/repositories/tag_repository.dart';
import '../../domain/usecases/add_source_usecase.dart';
import '../../domain/usecases/get_all_sources_usecase.dart';
import '../../domain/usecases/get_movies_by_category_usecase.dart';
import '../../domain/usecases/search_movies_usecase.dart';
import '../../data/datasources/local_datasource.dart';
import '../../data/datasources/local_datasource_impl.dart';
import '../../data/repositories/movie_repository_impl.dart';
import '../../data/repositories/source_repository_impl.dart';
import '../../data/repositories/proxy_repository_impl.dart';
import '../../data/repositories/tag_repository_impl.dart';

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