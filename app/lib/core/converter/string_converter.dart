import '../../core/extension.dart';

/// 字符串转换器
///
/// 用于接收接口返回数据的Json解析,
///
/// 如接口返回123, 但期望接收为'123'时.
///
/// ```dart
/// @JsonKey(fromJson: StringConverter.toStringOrNull)
/// final String xxx;
/// ```
abstract final class StringConverter {
  /// 转为字符串 非空
  static String toStringify(Object value) => value.toString();

  /// 转为字符串 可空
  static String? toStringifyOrNull(Object? value) => value?.let(toStringify);

  /// 转为字符串或空字符串
  static String toStringifyOrEmpty(Object? value) =>
      toStringifyOrNull(value) ?? '';
}
