import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sjgtv/src/movie/usecase/search_movies_usecase.dart';
import 'package:sjgtv/src/proxy/provider/proxies_provider.dart';
import 'package:sjgtv/src/source/provider/sources_provider.dart';

/// 电影 Use Case 工厂
///
/// 负责创建和提供电影相关的 Use Cases
class MovieUseCaseFactory {
  MovieUseCaseFactory._();

  /// 创建搜索电影 Use Case
  static SearchMoviesUseCase createSearchMoviesUseCase(Ref ref) {
    return SearchMoviesUseCase(
      getSources: () => ref.read(sourcesProvider.future),
      getProxies: () => ref.read(proxiesStorageProvider.future),
    );
  }
}