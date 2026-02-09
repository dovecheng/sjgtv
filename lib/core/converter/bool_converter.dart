/// 布尔转换器
///
/// 将字符串或数字转为布尔值
abstract final class BoolConverter {
  /// 转为布尔值, 非空
  static bool toBool(Object value) => toBoolOrNull(value)!;

  /// 转为布尔值, 可空
  static bool? toBoolOrNull(Object? value) => switch (value) {
    'no' || 'No' || 'NO' || '0' || 0 => false,
    'yes' || 'Yes' || 'YES' || '1' || 1 => true,
    String it => bool.tryParse(it, caseSensitive: false),
    bool it => it,
    _ => null,
  };

  /// 转为布尔值, 默认值为假
  static bool toBoolOrFalse(Object? value) => toBoolOrNull(value) ?? false;

  /// 转为布尔值, 默认是为真
  static bool toBoolOrTrue(Object? value) => toBoolOrNull(value) ?? true;
}
