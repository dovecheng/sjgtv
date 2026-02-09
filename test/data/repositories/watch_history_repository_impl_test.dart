import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/data/datasources/local_datasource.dart';
import 'package:sjgtv/data/repositories/watch_history_repository_impl.dart';
import 'package:sjgtv/domain/entities/watch_history.dart';

import 'watch_history_repository_impl_test.mocks.dart';

@GenerateMocks([LocalDataSource])
void main() {
  late WatchHistoryRepositoryImpl repository;
  late MockLocalDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockLocalDataSource();
    repository = WatchHistoryRepositoryImpl(localDataSource: mockDataSource);
  });

  group('WatchHistoryRepositoryImpl', () {
    final testHistories = [
      WatchHistory(
        id: '1',
        movieId: 'movie-1',
        movieTitle: '电影1',
        movieCoverUrl: 'http://pic1.jpg',
        movieYear: 2024,
        episodeIndex: 0,
        episodeName: '第1集',
        playUrl: 'http://ep1.m3u8',
        progress: Duration(minutes: 10),
        duration: Duration(minutes: 90),
        watchedAt: DateTime(2024, 1, 1),
        sourceName: '源1',
      ),
      WatchHistory(
        id: '2',
        movieId: 'movie-2',
        movieTitle: '电影2',
        movieCoverUrl: 'http://pic2.jpg',
        movieYear: 2024,
        episodeIndex: 1,
        episodeName: '第2集',
        playUrl: 'http://ep2.m3u8',
        progress: Duration(minutes: 5),
        duration: Duration(hours: 2),
        watchedAt: DateTime(2024, 1, 2),
        sourceName: '源2',
      ),
    ];

    group('getAllHistories', () {
      test('应该成功获取所有观看历史', () async {
        // arrange
        when(
          mockDataSource.getAllWatchHistories(),
        ).thenAnswer((_) async => Result.success(testHistories));

        // act
        final result = await repository.getAllHistories();

        // assert
        expect(result.isSuccess, true);
        result.when((_) => fail('应该返回成功结果'), (histories) {
          expect(histories.length, 2);
        });
        verify(mockDataSource.getAllWatchHistories());
      });

      test('应该返回失败当数据源出错时', () async {
        // arrange
        when(
          mockDataSource.getAllWatchHistories(),
        ).thenAnswer((_) async => Result.failure(CacheFailure('获取观看历史失败')));

        // act
        final result = await repository.getAllHistories();

        // assert
        expect(result.isFailure, true);
        verify(mockDataSource.getAllWatchHistories());
      });
    });

    group('addOrUpdateHistory', () {
      test('应该成功添加观看历史', () async {
        // arrange
        final newHistory = testHistories[0];
        when(
          mockDataSource.addOrUpdateWatchHistory(newHistory),
        ).thenAnswer((_) async => Result.success(newHistory));

        // act
        final result = await repository.addOrUpdateHistory(newHistory);

        // assert
        expect(result.isSuccess, true);
        verify(mockDataSource.addOrUpdateWatchHistory(newHistory));
      });

      test('应该返回失败当保存失败时', () async {
        // arrange
        final newHistory = testHistories[0];
        when(
          mockDataSource.addOrUpdateWatchHistory(newHistory),
        ).thenAnswer((_) async => Result.failure(CacheFailure('保存观看历史失败')));

        // act
        final result = await repository.addOrUpdateHistory(newHistory);

        // assert
        expect(result.isFailure, true);
        verify(mockDataSource.addOrUpdateWatchHistory(newHistory));
      });
    });

    group('deleteHistory', () {
      test('应该成功删除观看历史', () async {
        // arrange
        when(
          mockDataSource.deleteWatchHistory('1'),
        ).thenAnswer((_) async => Result.success(null));

        // act
        final result = await repository.deleteHistory('1');

        // assert
        expect(result.isSuccess, true);
        verify(mockDataSource.deleteWatchHistory('1'));
      });

      test('应该返回失败当删除失败时', () async {
        // arrange
        when(
          mockDataSource.deleteWatchHistory('1'),
        ).thenAnswer((_) async => Result.failure(CacheFailure('删除观看历史失败')));

        // act
        final result = await repository.deleteHistory('1');

        // assert
        expect(result.isFailure, true);
        verify(mockDataSource.deleteWatchHistory('1'));
      });
    });

    group('getHistoriesByMovie', () {
      test('应该成功获取指定电影的观看历史', () async {
        // arrange
        when(
          mockDataSource.getWatchHistoriesByMovie('movie-1'),
        ).thenAnswer((_) async => Result.success([testHistories[0]]));

        // act
        final result = await repository.getHistoriesByMovie('movie-1');

        // assert
        expect(result.isSuccess, true);
        result.when((_) => fail('应该返回成功结果'), (histories) {
          expect(histories.length, 1);
          expect(histories[0].movieId, 'movie-1');
        });
      });

      test('应该返回空列表当电影没有观看历史时', () async {
        // arrange
        when(
          mockDataSource.getWatchHistoriesByMovie('movie-999'),
        ).thenAnswer((_) async => Result.success([]));

        // act
        final result = await repository.getHistoriesByMovie('movie-999');

        // assert
        expect(result.isSuccess, true);
        result.when((_) => fail('应该返回成功结果'), (histories) {
          expect(histories, isEmpty);
        });
      });
    });

    group('clearAllHistories', () {
      test('应该成功清除所有观看历史', () async {
        // arrange
        when(
          mockDataSource.clearAllWatchHistories(),
        ).thenAnswer((_) async => Result.success(null));

        // act
        final result = await repository.clearAllHistories();

        // assert
        expect(result.isSuccess, true);
        verify(mockDataSource.clearAllWatchHistories());
      });
    });
  });
}
