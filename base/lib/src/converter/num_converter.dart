/// 数值转换器
///
/// 可以接收整型或双精度浮点数
///
/// 然后再根据需要[num.toInt]或[num.toDouble]
abstract final class NumConverter {
  /// 转为数值, 非空
  static num toNum(Object value) => toNumOrNull(value)!;

  /// 转为数值, 可空
  static num? toNumOrNull(Object? value) => switch (value) {
    String it => num.tryParse(it),
    num it => it,
    _ => null,
  };

  /// 转为数值, 默认值为零
  static num toNumOrZero(Object? value) => toNumOrNull(value) ?? 0;
}
