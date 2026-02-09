import 'dart:math' as math;

import 'package:intl/intl.dart';

extension L10nNumFormatExt on num {
  /// 缓存实例
  static final Map<String, NumberFormat> numberFormatters = {};

  /// 数字类型格式化
  ///
  /// [style] 格式
  ///
  ///   最多4位小数 `#.####`
  ///
  ///   最少4位小数 `0.0000`
  ///
  /// [allowRounding] 是否允许四舍五入, 默认不允许
  ///
  /// [usePlusSign] 是否使用正数加号前缀
  String format({
    String style = '#.####',
    bool allowRounding = false,
    bool usePlusSign = false,
  }) {
    NumberFormat formatter = numberFormatters.putIfAbsent(style, () {
      if (usePlusSign && this > 0) {
        style = '+$style';
      }
      return NumberFormat(style);
    });

    if (this is double && !allowRounding) {
      num multiple = math.pow(10, formatter.maximumFractionDigits);
      return formatter.format((this * multiple).toInt() / multiple);
    }

    return formatter.format(this);
  }
}
