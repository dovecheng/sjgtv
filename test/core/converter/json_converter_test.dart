import 'package:flutter_test/flutter_test.dart';
import 'package:sjgtv/core/converter/json_converter.dart';

void main() {
  group('JSONConverter', () {
    group('toJsonOrNull', () {
      test('应该处理 null 值', () {
        expect(JSONConverter.toJsonOrNull(null), isNull);
      });

      test('应该处理基本类型', () {
        expect(JSONConverter.toJsonOrNull(true), true);
        expect(JSONConverter.toJsonOrNull(42), 42);
        expect(JSONConverter.toJsonOrNull(3.14), 3.14);
        expect(JSONConverter.toJsonOrNull('hello'), 'hello');
      });

      test('应该处理 DateTime', () {
        final dateTime = DateTime(2026, 2, 9, 12, 30);
        expect(JSONConverter.toJsonOrNull(dateTime), '2026-02-09 12:30:00.000');
      });

      test('应该处理 List', () {
        final list = [1, 2, 3];
        final result = JSONConverter.toJsonOrNull(list);
        expect(result, equals([1, 2, 3]));
      });

      test('应该处理 Set', () {
        final set = {1, 2, 3};
        final result = JSONConverter.toJsonOrNull(set);
        expect(result, isA<Set>());
        expect((result as Set).containsAll([1, 2, 3]), true);
      });

      test('应该处理 Map', () {
        final map = {'key': 'value', 'number': 42};
        final result = JSONConverter.toJsonOrNull(map);
        expect(result, equals({'key': 'value', 'number': 42}));
      });

      test('应该处理嵌套对象', () {
        final obj = {
          'name': 'Test',
          'values': [1, 2, 3],
          'nested': {'a': 1, 'b': 2},
        };
        final result = JSONConverter.toJsonOrNull(obj);
        expect(result, equals(obj));
      });

      test('应该处理带 toJson 方法的对象', () {
        final obj = TestModel('Test', 42);
        final result = JSONConverter.toJsonOrNull(obj);
        expect(result, equals({'name': 'Test', 'value': 42}));
      });

      test('应该处理无 toJson 方法的对象', () {
        final obj = SimpleClass();
        final result = JSONConverter.toJsonOrNull(obj);
        expect(result, 'Instance of SimpleClass');
      });
    });

    group('fromJsonOrNull', () {
      test('应该处理 null 输入', () {
        expect(JSONConverter.fromJsonOrNull<String>(null), isNull);
      });

      test('应该处理字符串输入', () {
        expect(JSONConverter.fromJsonOrNull<String>('hello'), 'hello');
      });

      test('应该解析 JSON 字符串', () {
        final json = '{"name":"Test","value":42}';
        final result = JSONConverter.fromJsonOrNull<Map<String, dynamic>>(json);
        expect(result, isNotNull);
        expect(result?['name'], 'Test');
        expect(result?['value'], 42);
      });

      test('应该处理相同类型', () {
        expect(JSONConverter.fromJsonOrNull<int>(42), 42);
      });

      test('应该处理 List', () {
        final json = [1, 2, 3];
        final result = JSONConverter.fromJsonOrNull<List<int>>(json);
        expect(result, equals([1, 2, 3]));
      });
    });

    group('fromJsonArrayOrNull', () {
      test('应该处理 null 输入', () {
        expect(JSONConverter.fromJsonArrayOrNull<int>(null), isNull);
      });

      test('应该处理空数组', () {
        final json = <Object>[];
        final result = JSONConverter.fromJsonArrayOrNull<int>(json);
        expect(result, isEmpty);
      });

      test('应该解析 JSON 字符串数组', () {
        final json = '[1,2,3]';
        final result = JSONConverter.fromJsonArrayOrNull<int>(json);
        expect(result, equals([1, 2, 3]));
      });

      test('应该处理列表', () {
        final json = [1, 2, 3];
        final result = JSONConverter.fromJsonArrayOrNull<int>(json);
        expect(result, equals([1, 2, 3]));
      });

      test('应该处理非数组类型', () {
        final json = {'not': 'an array'};
        final result = JSONConverter.fromJsonArrayOrNull<int>(json);
        expect(result, isNull);
      });
    });

    group('toJsonStringify', () {
      test('应该将对象转换为 JSON 字符串', () {
        final obj = {'name': 'Test', 'value': 42};
        final result = JSONConverter.toJsonStringify(obj);
        expect(result, equals('{"name":"Test","value":42}'));
      });

      test('应该转换为带缩进的 JSON 字符串', () {
        final obj = {'name': 'Test', 'value': 42};
        final result = JSONConverter.toJsonStringify(obj, withIndent: true);
        expect(result, contains('\n'));
        expect(result, contains('  '));
      });

      test('应该处理 null', () {
        final result = JSONConverter.toJsonStringify(null);
        expect(result, equals('null'));
      });
    });

    group('register 和 findConverterOrNull', () {
      test('应该注册和查找转换器', () {
        String converter(Object? value) => value.toString().toUpperCase();
        JSONConverter.register<String>(converter);

        final found = JSONConverter.findConverterOrNull<String>();
        expect(found, isNotNull);
        expect(found!.call('test'), equals('TEST'));
      });

      test('应该查找未注册的转换器', () {
        final found = JSONConverter.findConverterOrNull<TestModel>();
        expect(found, isNull);
      });
    });

    group('fromJsonArrayOrEmpty', () {
      test('应该返回空数组当输入为 null', () {
        final result = JSONConverter.fromJsonArrayOrEmpty<int>(null);
        expect(result, isEmpty);
      });

      test('应该返回空数组当输入为空数组', () {
        final result = JSONConverter.fromJsonArrayOrEmpty<int>([]);
        expect(result, isEmpty);
      });

      test('应该解析有效的数组', () {
        final result = JSONConverter.fromJsonArrayOrEmpty<int>([1, 2, 3]);
        expect(result, equals([1, 2, 3]));
      });
    });
  });
}

/// 测试模型类
class TestModel {
  final String name;
  final int value;

  TestModel(this.name, this.value);

  Map<String, dynamic> toJson() {
    return {'name': name, 'value': value};
  }
}

/// 简单类（无 toJson 方法）
class SimpleClass {
  @override
  String toString() => 'Instance of SimpleClass';
}
