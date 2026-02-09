import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/favorite.dart';
import 'package:sjgtv/domain/repositories/favorite_repository.dart';
import 'package:sjgtv/domain/usecases/add_favorite_usecase.dart';

import 'add_favorite_usecase_test.mocks.dart';

@GenerateMocks([FavoriteRepository])
void main() {
  late AddFavoriteUseCase useCase;
  late MockFavoriteRepository mockRepository;

  setUp(() {
    mockRepository = MockFavoriteRepository();
    useCase = AddFavoriteUseCase(mockRepository);
  });

  group('AddFavoriteUseCase', () {
    final testFavorite = Favorite(
      uuid: '1',
      movieId: 'movie-1',
      movieTitle: '测试电影',
      movieCoverUrl: 'http://pic.jpg',
      movieYear: 2024,
      movieRating: 8.0,
      sourceName: '测试源',
      createdAt: DateTime(2024, 1, 1),
    );

    test('应该成功添加收藏', () async {
      // arrange
      when(
        mockRepository.addFavorite(testFavorite),
      ).thenAnswer((_) async => Result.success(testFavorite));

      // act
      final result = await useCase(testFavorite);

      // assert
      expect(result.isSuccess, true);
      result.when((_) => fail('应该返回成功结果'), (favorite) {
        expect(favorite.movieId, 'movie-1');
        expect(favorite.movieTitle, '测试电影');
      });
      verify(mockRepository.addFavorite(testFavorite));
    });

    test('应该返回失败当添加失败时', () async {
      // arrange
      when(mockRepository.addFavorite(testFavorite)).thenAnswer(
        (_) async => Result.failure(CacheFailure('添加收藏失败: Duplicate key')),
      );

      // act
      final result = await useCase(testFavorite);

      // assert
      expect(result.isFailure, true);
      result.when((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('添加收藏失败'));
      }, (_) => fail('应该返回失败结果'));
      verify(mockRepository.addFavorite(testFavorite));
    });

    test('应该处理完整的收藏对象', () async {
      // arrange
      final completeFavorite = Favorite(
        uuid: 'test-uuid',
        movieId: 'movie-123',
        movieTitle: '完整测试电影',
        movieCoverUrl: 'http://complete.jpg',
        movieYear: 2024,
        movieRating: 9.0,
        sourceName: '完整测试源',
        createdAt: DateTime(2024, 2, 9, 10, 30),
      );

      when(
        mockRepository.addFavorite(completeFavorite),
      ).thenAnswer((_) async => Result.success(completeFavorite));

      // act
      final result = await useCase(completeFavorite);

      // assert
      expect(result.isSuccess, true);
      result.when((_) => fail('应该返回成功结果'), (favorite) {
        expect(favorite.movieId, 'movie-123');
        expect(favorite.movieCoverUrl, 'http://complete.jpg');
      });
    });
  });
}
