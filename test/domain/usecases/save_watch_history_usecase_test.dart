import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/watch_history.dart';
import 'package:sjgtv/domain/repositories/watch_history_repository.dart';
import 'package:sjgtv/domain/usecases/save_watch_history_usecase.dart';

import 'save_watch_history_usecase_test.mocks.dart';

@GenerateMocks([WatchHistoryRepository])
void main() {
  late SaveWatchHistoryUseCase useCase;
  late MockWatchHistoryRepository mockRepository;

  setUp(() {
    mockRepository = MockWatchHistoryRepository();
    useCase = SaveWatchHistoryUseCase(mockRepository);
  });

  group('SaveWatchHistoryUseCase', () {
    final testHistory = WatchHistory(
      id: '1',
      movieId: 'movie-1',
      movieTitle: '测试电影',
      movieCoverUrl: 'http://pic.jpg',
      movieYear: 2024,
      episodeIndex: 0,
      episodeName: '第1集',
      playUrl: 'http://episode1.m3u8',
      progress: Duration(minutes: 10),
      duration: Duration(minutes: 90),
      watchedAt: DateTime(2024, 1, 1),
      sourceName: '测试源',
    );

    test('应该成功保存观看历史', () async {
      // arrange
      final params = SaveWatchHistoryParams(history: testHistory);

      when(
        mockRepository.addOrUpdateHistory(testHistory),
      ).thenAnswer((_) async => Result.success(testHistory));

      // act
      final result = await useCase(params);

      // assert
      expect(result.isSuccess, true);
      result.when((_) => fail('应该返回成功结果'), (history) {
        expect(history.movieId, 'movie-1');
        expect(history.movieTitle, '测试电影');
        expect(history.progress, Duration(minutes: 10));
      });
      verify(mockRepository.addOrUpdateHistory(testHistory));
    });

    test('应该更新已存在的观看历史', () async {
      // arrange
      final updatedHistory = testHistory.copyWith(
        progress: Duration(minutes: 20),
        watchedAt: DateTime(2024, 1, 2),
      );

      final params = SaveWatchHistoryParams(history: updatedHistory);

      when(
        mockRepository.addOrUpdateHistory(updatedHistory),
      ).thenAnswer((_) async => Result.success(updatedHistory));

      // act
      final result = await useCase(params);

      // assert
      expect(result.isSuccess, true);
      result.when((_) => fail('应该返回成功结果'), (history) {
        expect(history.progress, Duration(minutes: 20));
        expect(history.watchedAt, DateTime(2024, 1, 2));
      });
      verify(mockRepository.addOrUpdateHistory(updatedHistory));
    });

    test('应该返回失败当保存失败时', () async {
      // arrange
      final params = SaveWatchHistoryParams(history: testHistory);

      when(mockRepository.addOrUpdateHistory(testHistory)).thenAnswer(
        (_) async => Result.failure(CacheFailure('保存观看历史失败: Database error')),
      );

      // act
      final result = await useCase(params);

      // assert
      expect(result.isFailure, true);
      result.when((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('保存观看历史失败'));
      }, (_) => fail('应该返回失败结果'));
      verify(mockRepository.addOrUpdateHistory(testHistory));
    });

    test('应该处理完整的观看历史对象', () async {
      // arrange
      final completeHistory = WatchHistory(
        id: 'test-uuid',
        movieId: 'movie-123',
        movieTitle: '完整测试电影',
        movieCoverUrl: 'http://complete.jpg',
        movieYear: 2024,
        episodeIndex: 5,
        episodeName: '第6集',
        playUrl: 'http://episode6.m3u8',
        progress: Duration(minutes: 45, seconds: 30),
        duration: Duration(hours: 2, minutes: 15),
        watchedAt: DateTime(2024, 2, 9, 10, 30),
        sourceName: '完整测试源',
      );

      final params = SaveWatchHistoryParams(history: completeHistory);

      when(
        mockRepository.addOrUpdateHistory(completeHistory),
      ).thenAnswer((_) async => Result.success(completeHistory));

      // act
      final result = await useCase(params);

      // assert
      expect(result.isSuccess, true);
      result.when((_) => fail('应该返回成功结果'), (history) {
        expect(history.episodeIndex, 5);
        expect(history.episodeName, '第6集');
        expect(history.progress, Duration(minutes: 45, seconds: 30));
        expect(history.duration, Duration(hours: 2, minutes: 15));
      });
    });
  });
}
