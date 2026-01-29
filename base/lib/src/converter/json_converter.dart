import 'dart:convert';

import 'package:base/converter.dart';
import 'package:base/log.dart';
import 'package:meta/meta.dart';

/// Json转换器
///
/// - Json转实体
/// - 实体转Json
abstract final class JSONConverter {
  @visibleForTesting
  static final Log log = (JSONConverter).log;

  /// minimized
  ///
  /// 与sdk的[jsonEncode]区别: 不能转json的类型将会[toString]处理
  static const JsonEncoder jsonEncoder = JsonEncoder(toJsonOrNull);

  /// pretty-print
  ///
  /// 与sdk的[jsonEncode]区别: 不能转json的类型将会[toString]处理
  static const JsonEncoder jsonEncoderWithIndent = JsonEncoder.withIndent(
    '  ',
    toJsonOrNull,
  );

  /// 注册的转换方法
  static final Map<Type, Function> _converters = {
    Null: (_) => null,
    bool: BoolConverter.toBoolOrNull,
    num: NumConverter.toNumOrNull,
    int: IntConverter.toIntOrNull,
    double: DoubleConverter.toDoubleOrNull,
    String: StringConverter.toStringifyOrNull,
    DateTime: DateTimeConverter.toDateTimeByUtcOrNull,
  };

  /// 注册基本类型转换方法
  static void register<T extends Object>(
    T? Function(Object? value) converter,
  ) => _converters[T] = converter;

  /// 注册实体[fromJson]构造方法, 或自定义的实体转换方法
  ///
  /// **不需要为集合注册**
  static void registerFromJson<T extends Object>(
    T? Function(Map<String, dynamic> json) converter,
  ) => _converters[T] = converter;

  /// 查找转换方法, 非空
  ///
  /// **请确保已调用[register]或[registerFromJson]方法注册转换**
  static Function findConverter<T extends Object>() =>
      findConverterOrNull<T>()!;

  /// 查找转换方法, 可空
  ///
  /// **请确保已调用[register]或[registerFromJson]方法注册转换**
  static Function? findConverterOrNull<T extends Object>() {
    Function? converter = _converters[T];
    if (converter == null) {
      log.w(
        () =>
            '$T converter is not registered! \n'
            'please call `JSONConverter.registerFromJson($T.fromJson);` or `JSONConverter.register(FN);`',
      );
    }
    return converter;
  }

  /// 根据接收方法返回类型的泛型解析Json(单个), 非空
  static T fromJson<T extends Object>(Object json) => fromJsonOrNull<T>(json)!;

  /// 根据接收方法返回类型的泛型解析Json(单个), 可空
  static T? fromJsonOrNull<T extends Object>(Object? json) {
    if (json == null) {
      return null;
    }
    if (json is String && T != String && T != Object) {
      json = jsonDecode(json);
    }
    if (json is T) {
      return json;
    }
    Function? converter = findConverterOrNull<T>();
    if (converter != null) {
      return converter(json);
    }
    return json as T?;
  }

  /// 根据接收方法返回类型的泛型解析Json(集合), 非空
  static List<T> fromJsonArray<T extends Object>(Object json) =>
      fromJsonArrayOrNull<T>(json)!;

  /// 根据接收方法返回类型的泛型解析Json(集合), 默认为空集合
  static List<T> fromJsonArrayOrEmpty<T extends Object>(Object? json) =>
      fromJsonArrayOrNull<T>(json) ?? [];

  /// 根据接收方法返回类型的泛型解析Json(集合), 可空
  static List<T>? fromJsonArrayOrNull<T extends Object>(Object? json) {
    if (json == null) {
      return null;
    }
    if (json is String) {
      json = jsonDecode(json);
    }
    if (json is! Iterable) {
      log.w(() => 'json ${json.runtimeType} typed is not array: $json');
      return null;
    }
    if (json.isEmpty) {
      return [];
    }
    Function? converter = findConverterOrNull<T>();
    if (converter != null) {
      return json.map<T>((Object? e) => converter.call(e)).toList();
    }
    return List<T>.from(json);
  }

  /// 转为Json类型, 非空
  ///
  /// 可能是: [List], [Map] 或 基本数据类型
  static Object toJson(Object object) => toJsonOrNull(object)!;

  /// 转为Json类型, 可空
  ///
  /// 可能是: [List], [Map] 或 基本数据类型
  static Object? toJsonOrNull(Object? object) => switch (object) {
    null => null,
    bool _ || num _ || String _ => object,
    DateTime _ => object.toString(),
    List<Object?> _ => object.map(toJsonOrNull).toList(),
    Set<Object?> _ => object.map(toJsonOrNull).toSet(),
    Iterable<Object?> _ => object.map(toJsonOrNull),
    Map<Object?, Object?> _ => Map<Object?, Object?>.fromIterables(
      toJsonOrNull(object.keys) as Iterable<Object?>,
      toJsonOrNull(object.values) as Iterable<Object?>,
    ),
    _ => _invokeToJson(object),
  };

  static Object? _invokeToJson(Object object) {
    try {
      return (object as dynamic).toJson();
    } on NoSuchMethodError {
      try {
        return (object as dynamic).toMap();
      } on NoSuchMethodError {
        return object.toString();
      }
    }
  }

  /// 转为Json字符串
  ///
  /// 与sdk的[jsonEncode]区别: 不能转json的类型将会[toString]处理
  static String toJsonStringify(Object? object, {bool withIndent = false}) =>
      withIndent
      ? jsonEncoderWithIndent.convert(object)
      : jsonEncoder.convert(object);
}
