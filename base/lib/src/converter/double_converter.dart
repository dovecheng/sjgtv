/// 双精度浮点数转换器
abstract final class DoubleConverter {
  /// 转为双精度浮点数值, 非空
  static double toDouble(Object value) => toDoubleOrNull(value)!;

  /// 转为双精度浮点数值, 可空
  static double? toDoubleOrNull(Object? value) => switch (value) {
    String it => num.tryParse(it)?.toDouble(),
    num it => it.toDouble(),
    _ => null,
  };

  /// 转为双精度浮点数值, 默认值为零
  static double toDoubleOrZero(Object? value) => toDoubleOrNull(value) ?? 0;
}
