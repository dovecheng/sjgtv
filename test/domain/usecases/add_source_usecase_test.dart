import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/source.dart';
import 'package:sjgtv/domain/repositories/source_repository.dart';
import 'package:sjgtv/domain/usecases/add_source_usecase.dart';

import 'add_source_usecase_test.mocks.dart';

@GenerateMocks([SourceRepository])
void main() {
  late AddSourceUseCase useCase;
  late MockSourceRepository mockRepository;

  setUp(() {
    mockRepository = MockSourceRepository();
    useCase = AddSourceUseCase(mockRepository);
  });

  group('AddSourceUseCase', () {
    test('应该成功添加视频源', () async {
      // arrange
      const params = AddSourceParams(
        name: '新视频源',
        url: 'http://new-source.com',
        weight: 5,
        disabled: false,
        tagIds: ['tag1', 'tag2'],
      );

      when(mockRepository.addSource(any)).thenAnswer((realInvocation) async {
        final source = realInvocation.positionalArguments[0] as Source;
        return Result.success(source);
      });

      // act
      final result = await useCase(params);

      // assert
      expect(result.isSuccess, true);
      result.when((_) => fail('应该返回成功结果'), (source) {
        expect(source.name, '新视频源');
        expect(source.url, 'http://new-source.com');
        expect(source.weight, 5);
        expect(source.disabled, false);
        expect(source.tagIds, ['tag1', 'tag2']);
      });
      verify(
        mockRepository.addSource(
          argThat(
            isA<Source>()
                .having((s) => s.name, 'name', '新视频源')
                .having((s) => s.url, 'url', 'http://new-source.com'),
          ),
        ),
      );
    });

    test('应该使用默认参数', () async {
      // arrange
      const params = AddSourceParams(name: '默认源', url: 'http://default.com');

      when(mockRepository.addSource(any)).thenAnswer((realInvocation) async {
        final source = realInvocation.positionalArguments[0] as Source;
        return Result.success(source);
      });

      // act
      await useCase(params);

      // assert
      verify(
        mockRepository.addSource(
          argThat(
            isA<Source>()
                .having((s) => s.weight, 'weight', 5)
                .having((s) => s.disabled, 'disabled', false)
                .having((s) => s.tagIds, 'tagIds', []),
          ),
        ),
      );
    });

    test('应该返回失败当添加失败时', () async {
      // arrange
      const params = AddSourceParams(name: '重复源', url: 'http://duplicate.com');

      when(mockRepository.addSource(any)).thenAnswer(
        (_) async => Result.failure(CacheFailure('添加视频源失败: Duplicate key')),
      );

      // act
      final result = await useCase(params);

      // assert
      expect(result.isFailure, true);
      result.when((failure) {
        expect(failure, isA<CacheFailure>());
        expect(failure.message, contains('添加视频源失败'));
      }, (_) => fail('应该返回失败结果'));
      verify(mockRepository.addSource(any));
    });

    test('应该生成唯一的 UUID', () async {
      // arrange
      const params1 = AddSourceParams(name: '源1', url: 'http://1.com');
      const params2 = AddSourceParams(name: '源2', url: 'http://2.com');

      when(mockRepository.addSource(any)).thenAnswer((realInvocation) async {
        final source = realInvocation.positionalArguments[0] as Source;
        return Result.success(source);
      });

      // act
      final result1 = await useCase(params1);
      // 添加延迟以确保时间戳不同
      await Future.delayed(const Duration(milliseconds: 2));
      final result2 = await useCase(params2);

      // assert
      result1.when((_) {}, (source1) {
        result2.when((_) {}, (source2) {
          expect(source1.uuid, isNot(equals(source2.uuid)));
        });
      });
    });
  });
}
