import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/source.dart';
import 'package:sjgtv/domain/repositories/source_repository.dart';
import 'package:sjgtv/domain/usecases/get_all_sources_usecase.dart';

import 'get_all_sources_usecase_test.mocks.dart';

@GenerateMocks([SourceRepository])
void main() {
  late GetAllSourcesUseCase useCase;
  late MockSourceRepository mockRepository;

  setUp(() {
    mockRepository = MockSourceRepository();
    useCase = GetAllSourcesUseCase(mockRepository);
  });

  group('GetAllSourcesUseCase', () {
    final testSources = [
      Source(
        uuid: '1',
        name: '测试源1',
        url: 'http://test1.com',
        weight: 5,
        disabled: false,
        tagIds: [],
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      ),
      Source(
        uuid: '2',
        name: '测试源2',
        url: 'http://test2.com',
        weight: 10,
        disabled: true,
        tagIds: ['tag1'],
        createdAt: DateTime(2024, 1, 2),
        updatedAt: DateTime(2024, 1, 2),
      ),
    ];

    test('应该成功获取所有视频源', () async {
      // arrange
      when(mockRepository.getAllSources())
          .thenAnswer((_) async => Result.success(testSources));

      // act
      final result = await useCase();

      // assert
      expect(result.isSuccess, true);
      result.when(
        (_) => fail('应该返回成功结果'),
        (sources) {
          expect(sources.length, 2);
          expect(sources[0].name, '测试源1');
          expect(sources[1].name, '测试源2');
        },
      );
      verify(mockRepository.getAllSources());
      verifyNoMoreInteractions(mockRepository);
    });

    test('应该返回空列表当没有源时', () async {
      // arrange
      when(mockRepository.getAllSources())
          .thenAnswer((_) async => Result.success([]));

      // act
      final result = await useCase();

      // assert
      expect(result.isSuccess, true);
      result.when(
        (_) => fail('应该返回成功结果'),
        (sources) {
          expect(sources, isEmpty);
        },
      );
      verify(mockRepository.getAllSources());
    });

    test('应该返回失败当数据库出错时', () async {
      // arrange
      when(mockRepository.getAllSources()).thenAnswer(
        (_) async => Result.failure(
          CacheFailure('获取视频源失败: Database error'),
        ),
      );

      // act
      final result = await useCase();

      // assert
      expect(result.isFailure, true);
      result.when(
        (failure) {
          expect(failure, isA<CacheFailure>());
          expect(failure.message, contains('获取视频源失败'));
        },
        (_) => fail('应该返回失败结果'),
      );
      verify(mockRepository.getAllSources());
    });
  });
}