/// 整型转换器
abstract final class IntConverter {
  /// 转为整型, 非空
  static int toInt(Object value) => toIntOrNull(value)!;

  /// 转为整型, 可空
  static int? toIntOrNull(Object? value) => switch (value) {
    String it => num.tryParse(it)?.toInt(),
    num it => it.toInt(),
    _ => null,
  };

  /// 转为整型, 默认值为零
  static int toIntOrZero(Object? value) => toIntOrNull(value) ?? 0;
}
