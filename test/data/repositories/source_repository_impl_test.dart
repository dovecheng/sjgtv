import 'package:dio/dio.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/data/datasources/local_datasource.dart';
import 'package:sjgtv/data/repositories/source_repository_impl.dart';
import 'package:sjgtv/domain/entities/source.dart';

import 'source_repository_impl_test.mocks.dart';

@GenerateMocks([LocalDataSource, Dio])
void main() {
  late SourceRepositoryImpl repository;
  late MockLocalDataSource mockDataSource;
  late MockDio mockDio;

  setUp(() {
    mockDataSource = MockLocalDataSource();
    mockDio = MockDio();
    repository = SourceRepositoryImpl(
      localDataSource: mockDataSource,
      dio: mockDio,
    );
  });

  group('SourceRepositoryImpl', () {
    final testSources = [
      Source(
        uuid: '1',
        name: '测试源1',
        url: 'http://test1.com',
        weight: 5,
        disabled: false,
        tagIds: ['tag1'],
        createdAt: DateTime(2024, 1, 1),
        updatedAt: DateTime(2024, 1, 1),
      ),
      Source(
        uuid: '2',
        name: '测试源2',
        url: 'http://test2.com',
        weight: 10,
        disabled: true,
        tagIds: ['tag2'],
        createdAt: DateTime(2024, 1, 2),
        updatedAt: DateTime(2024, 1, 2),
      ),
    ];

    group('getAllSources', () {
      test('应该成功获取所有源', () async {
        // arrange
        when(
          mockDataSource.getAllSources(),
        ).thenAnswer((_) async => Result.success(testSources));

        // act
        final result = await repository.getAllSources();

        // assert
        expect(result.isSuccess, true);
        result.when((_) => fail('应该返回成功结果'), (sources) {
          expect(sources.length, 2);
        });
        verify(mockDataSource.getAllSources());
      });

      test('应该返回失败当数据源出错时', () async {
        // arrange
        when(
          mockDataSource.getAllSources(),
        ).thenAnswer((_) async => Result.failure(CacheFailure('获取视频源失败')));

        // act
        final result = await repository.getAllSources();

        // assert
        expect(result.isFailure, true);
        verify(mockDataSource.getAllSources());
      });
    });

    group('getSourcesByTag', () {
      test('应该根据标签过滤源', () async {
        // arrange
        when(
          mockDataSource.getAllSources(),
        ).thenAnswer((_) async => Result.success(testSources));

        // act
        final result = await repository.getSourcesByTag('tag1');

        // assert
        expect(result.isSuccess, true);
        result.when((_) => fail('应该返回成功结果'), (sources) {
          expect(sources.length, 1);
          expect(sources[0].uuid, '1');
          expect(sources[0].tagIds, contains('tag1'));
        });
      });

      test('应该返回空列表当没有匹配的标签时', () async {
        // arrange
        when(
          mockDataSource.getAllSources(),
        ).thenAnswer((_) async => Result.success(testSources));

        // act
        final result = await repository.getSourcesByTag('tag3');

        // assert
        expect(result.isSuccess, true);
        result.when((_) => fail('应该返回成功结果'), (sources) {
          expect(sources, isEmpty);
        });
      });

      test('应该传递错误当获取源列表失败时', () async {
        // arrange
        when(
          mockDataSource.getAllSources(),
        ).thenAnswer((_) async => Result.failure(CacheFailure('错误')));

        // act
        final result = await repository.getSourcesByTag('tag1');

        // assert
        expect(result.isFailure, true);
      });
    });

    group('addSource', () {
      test('应该成功添加源', () async {
        // arrange
        final newSource = testSources[0];
        when(
          mockDataSource.addSource(newSource),
        ).thenAnswer((_) async => Result.success(newSource));

        // act
        final result = await repository.addSource(newSource);

        // assert
        expect(result.isSuccess, true);
        verify(mockDataSource.addSource(newSource));
      });
    });

    group('updateSource', () {
      test('应该成功更新源', () async {
        // arrange
        final updatedSource = testSources[0].copyWith(name: '更新后的源');
        when(
          mockDataSource.updateSource(updatedSource),
        ).thenAnswer((_) async => Result.success(updatedSource));

        // act
        final result = await repository.updateSource(updatedSource);

        // assert
        expect(result.isSuccess, true);
        verify(mockDataSource.updateSource(updatedSource));
      });
    });

    group('deleteSource', () {
      test('应该成功删除源', () async {
        // arrange
        when(
          mockDataSource.deleteSource('1'),
        ).thenAnswer((_) async => Result.success(null));

        // act
        final result = await repository.deleteSource('1');

        // assert
        expect(result.isSuccess, true);
        verify(mockDataSource.deleteSource('1'));
      });
    });

    group('toggleSource', () {
      test('应该成功切换源的启用状态', () async {
        // arrange
        when(
          mockDataSource.getAllSources(),
        ).thenAnswer((_) async => Result.success(testSources));
        when(
          mockDataSource.updateSource(any),
        ).thenAnswer((_) async => Result.success(testSources[0]));

        // act
        final result = await repository.toggleSource('1');

        // assert
        expect(result.isSuccess, true);
        verify(mockDataSource.getAllSources());
        verify(
          mockDataSource.updateSource(
            argThat(
              isA<Source>().having((s) => s.disabled, 'disabled', isTrue),
            ),
          ),
        );
      });

      test('应该返回失败当源不存在时', () async {
        // arrange
        when(
          mockDataSource.getAllSources(),
        ).thenAnswer((_) async => Result.success(testSources));

        // act
        final result = await repository.toggleSource('999');

        // assert
        expect(result.isFailure, true);
        result.when((failure) {
          expect(failure, isA<NotFoundFailure>());
        }, (_) => fail('应该返回失败结果'));
      });
    });

    group('testSource', () {
      test('应该成功测试源连接', () async {
        // arrange
        when(
          mockDataSource.getAllSources(),
        ).thenAnswer((_) async => Result.success(testSources));

        final mockResponse = Response<dynamic>(
          data: {'code': 1, 'msg': 'success'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );
        when(
          mockDio.get<dynamic>(
            'http://test1.com',
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // act
        final result = await repository.testSource('1');

        // assert
        expect(result.isSuccess, true);
        result.when(
          (_) => fail('应该返回成功结果'),
          (success) => expect(success, isTrue),
        );
      });

      test('应该返回失败当源不存在时', () async {
        // arrange
        when(
          mockDataSource.getAllSources(),
        ).thenAnswer((_) async => Result.success(testSources));

        // act
        final result = await repository.testSource('999');

        // assert
        expect(result.isFailure, true);
      });

      test('应该返回 false 当测试失败时', () async {
        // arrange
        when(
          mockDataSource.getAllSources(),
        ).thenAnswer((_) async => Result.success(testSources));

        final mockResponse = Response<dynamic>(
          data: {'code': 0, 'msg': 'failed'},
          statusCode: 200,
          requestOptions: RequestOptions(path: ''),
        );
        when(
          mockDio.get<dynamic>(
            any,
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
          ),
        ).thenAnswer((_) async => mockResponse);

        // act
        final result = await repository.testSource('1');

        // assert
        expect(result.isSuccess, true);
        result.when(
          (_) => fail('应该返回成功结果'),
          (success) => expect(success, isFalse),
        );
      });

      test('应该返回失败当网络请求出错时', () async {
        // arrange
        when(
          mockDataSource.getAllSources(),
        ).thenAnswer((_) async => Result.success(testSources));

        when(
          mockDio.get<dynamic>(
            any,
            queryParameters: anyNamed('queryParameters'),
            options: anyNamed('options'),
          ),
        ).thenThrow(
          DioException(
            requestOptions: RequestOptions(path: ''),
            type: DioExceptionType.connectionTimeout,
          ),
        );

        // act
        final result = await repository.testSource('1');

        // assert
        expect(result.isFailure, true);
        result.when((failure) {
          expect(failure, isA<NetworkFailure>());
        }, (_) => fail('应该返回失败结果'));
      });
    });
  });
}
