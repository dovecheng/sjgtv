import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/watch_history.dart';
import 'package:sjgtv/domain/repositories/watch_history_repository.dart';
import 'package:sjgtv/domain/usecases/get_all_watch_histories_usecase.dart';

import 'get_all_watch_histories_usecase_test.mocks.dart';

@GenerateMocks([WatchHistoryRepository])
void main() {
  late GetAllWatchHistoriesUseCase useCase;
  late MockWatchHistoryRepository mockRepository;

  setUp(() {
    mockRepository = MockWatchHistoryRepository();
    useCase = GetAllWatchHistoriesUseCase(mockRepository);
  });

  group('GetAllWatchHistoriesUseCase', () {
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

    test('应该成功获取所有观看历史', () async {
      // arrange
      when(mockRepository.getAllHistories())
          .thenAnswer((_) async => Result.success(testHistories));

      // act
      final result = await useCase();

      // assert
      expect(result.isSuccess, true);
      result.when(
        (_) => fail('应该返回成功结果'),
        (histories) {
          expect(histories.length, 2);
          expect(histories[0].movieTitle, '电影1');
          expect(histories[1].movieTitle, '电影2');
        },
      );
      verify(mockRepository.getAllHistories());
    });

    test('应该返回空列表当没有观看历史时', () async {
      // arrange
      when(mockRepository.getAllHistories())
          .thenAnswer((_) async => Result.success([]));

      // act
      final result = await useCase();

      // assert
      expect(result.isSuccess, true);
      result.when(
        (_) => fail('应该返回成功结果'),
        (histories) {
          expect(histories, isEmpty);
        },
      );
      verify(mockRepository.getAllHistories());
    });

    test('应该返回失败当数据库出错时', () async {
      // arrange
      when(mockRepository.getAllHistories()).thenAnswer(
        (_) async => Result.failure(
          CacheFailure('获取观看历史失败: Database error'),
        ),
      );

      // act
      final result = await useCase();

      // assert
      expect(result.isFailure, true);
      result.when(
        (failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, contains('获取观看历史失败'));
        },
        (_) => fail('应该返回失败结果'),
      );
      verify(mockRepository.getAllHistories());
    });

    test('应该按时间倒序返回观看历史', () async {
      // arrange
      final histories = [
        WatchHistory(
          id: '2',
          movieId: '2',
          movieTitle: '新电影',
          movieCoverUrl: '',
          movieYear: 2024,
          episodeIndex: 0,
          episodeName: '第1集',
          playUrl: '',
          progress: Duration.zero,
          duration: Duration(hours: 1),
          watchedAt: DateTime(2024, 1, 2),
          sourceName: '源',
        ),
        WatchHistory(
          id: '1',
          movieId: '1',
          movieTitle: '旧电影',
          movieCoverUrl: '',
          movieYear: 2024,
          episodeIndex: 0,
          episodeName: '第1集',
          playUrl: '',
          progress: Duration.zero,
          duration: Duration(hours: 1),
          watchedAt: DateTime(2024, 1, 1),
          sourceName: '源',
        ),
      ];

      when(mockRepository.getAllHistories())
          .thenAnswer((_) async => Result.success(histories));

      // act
      final result = await useCase();

      // assert
      result.when(
        (_) {},
        (historyList) {
          expect(historyList[0].watchedAt, DateTime(2024, 1, 2));
          expect(historyList[1].watchedAt, DateTime(2024, 1, 1));
        },
      );
    });
  });
}