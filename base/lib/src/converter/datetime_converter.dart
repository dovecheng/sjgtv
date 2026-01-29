import 'package:collection/collection.dart';
import 'package:intl/intl.dart';

/// 日期转换器
///
/// 将日期格式字符串或时间戳转为日期对象
abstract final class DateTimeConverter {
  /// 日期规则
  static final Map<RegExp, DateFormat> _dateFormatRE = {
    // 年月日时分秒毫秒
    RegExp(r'^\d{2,4}-\d{1,2}-\d{1,2} \d{1,2}:\d{1,2}:\d{1,2}\.\d{1,3}[Zz]?$'):
        DateFormat('yy-M-d H:m:s.S'),
    RegExp(r'^\d{2,4}/\d{1,2}/\d{1,2} \d{1,2}:\d{1,2}:\d{1,2}\.\d{1,3}[Zz]?$'):
        DateFormat('yy/M/d H:m:s.S'),

    // 年月日时分秒
    RegExp(r'^\d{2,4}-\d{1,2}-\d{1,2} \d{1,2}:\d{1,2}:\d{1,2}[Zz]?$'):
        DateFormat('yy-M-d H:m:s'),
    RegExp(r'^\d{2,4}/\d{1,2}/\d{1,2} \d{1,2}:\d{1,2}:\d{1,2}[Zz]?$'):
        DateFormat('yy/M/d H:m:s'),

    // 年月日时分
    RegExp(r'^\d{2,4}-\d{1,2}-\d{1,2} \d{1,2}:\d{1,2}[Zz]?$'): DateFormat(
      'yy-M-d H:m',
    ),
    RegExp(r'^\d{2,4}/\d{1,2}/\d{1,2} \d{1,2}:\d{1,2}[Zz]?$'): DateFormat(
      'yy/M/d H:m',
    ),

    // 年月日
    RegExp(r'^\d{2,4}-\d{1,2}-\d{1,2}[Zz]?$'): DateFormat('yy-M-d'),
    RegExp(r'^\d{2,4}/\d{1,2}/\d{1,2}[Zz]?$'): DateFormat('yy/M/d'),

    // 时分秒毫秒
    RegExp(r'^\d{1,2}:\d{1,2}:\d{1,2}\.\d{1,3}[Zz]?$'): DateFormat('H:m:s.S'),

    // 时分秒
    RegExp(r'^\d{1,2}:\d{1,2}:\d{1,2}[Zz]?$'): DateFormat('H:m:s'),

    // 时分
    RegExp(r'^\d{1,2}:\d{1,2}[Zz]?$'): DateFormat('H:m'),
  };

  /// 时间戳规则
  static final RegExp _timestampRE = RegExp(r'^\d{1,16}$');

  /// 转为日期对象, 非空
  ///
  /// - [value] 日期字符串或时间戳数值或时间戳字符串
  /// - [withSeconds] 使用时间戳时以秒为单位, 而不是毫秒
  /// - [toUtc] 转换为UTC时区时间对象, 而不是本地时区
  static DateTime toDateTime(
    Object value, {
    bool withSeconds = false,
    bool toUtc = false,
  }) => toDateTimeOrNull(value, withSeconds: withSeconds, isUtc: toUtc)!;

  /// 年月日时分秒 或 年月日 或 时分秒 或 时间戳 转 [DateTime]
  ///
  /// - [withSeconds] 是否使用秒时间戳 默认为 `false`
  /// - [isUtc] 是否指定使用**UTC**时区 默认为 `false`
  static DateTime? toDateTimeOrNull(
    Object? value, {
    bool withSeconds = false,
    bool isUtc = false,
  }) {
    // 判断是否为int类型
    if (value is int) {
      // 通过时间戳转为`DateTime`类型
      return DateTime.fromMillisecondsSinceEpoch(
        // 是否使用秒时间戳
        withSeconds ? value * 1000 : value,
        isUtc: isUtc,
      );
    } else if (value is String) {
      // 判断是否为时间戳格式的字符串, 并转换为`int`类型
      if (_timestampRE.hasMatch(value)) {
        int? parse = int.tryParse(value);
        if (parse != null) {
          return toDateTimeOrNull(
            parse,
            withSeconds: withSeconds,
            isUtc: isUtc,
          );
        }
      }
      // 判断是否为年月日时分秒的字符串, 并直接转为`DateTime`类型
      DateFormat? dateFormat = _dateFormatRE.entries
          .firstWhereOrNull(
            (MapEntry<RegExp, DateFormat> entry) => entry.key.hasMatch(value),
          )
          ?.value;
      if (dateFormat != null) {
        return dateFormat.parse(value, isUtc);
      }

      // 以上都不匹配, 使用系统内置方式
      DateTime? parse = DateTime.tryParse(value);
      if (parse != null) {
        if (isUtc) {
          return parse.toUtc();
        }
        return parse;
      }
    }
    return null;
  }

  /// 转为UTC时区的时间对象, 非空
  static DateTime toDateTimeByUtc(Object value) =>
      toDateTimeOrNull(value, isUtc: true)!;

  /// 转为UTC时区的时间对象, 可空
  static DateTime? toDateTimeByUtcOrNull(Object? value) =>
      toDateTimeOrNull(value, isUtc: true);

  //region toDateTimeWithSeconds
  /// 使用秒时间戳转为UTC时区的时间对象, 非空
  static DateTime toDateTimeByUtcWithSeconds(Object value) =>
      toDateTimeByUtcWithSecondsOrNull(value)!;

  /// 使用秒时间戳转为UTC时区的时间对象, 可空
  static DateTime? toDateTimeByUtcWithSecondsOrNull(Object? value) =>
      toDateTimeOrNull(value, withSeconds: true, isUtc: true);

  /// 使用秒时间戳转为本地时区的时间对象, 非空
  static DateTime toDateTimeWithSeconds(Object value) =>
      toDateTimeWithSecondsOrNull(value)!;

  /// 使用秒时间戳转为本地时区的时间对象, 可空
  static DateTime? toDateTimeWithSecondsOrNull(Object? value) =>
      toDateTimeOrNull(value, withSeconds: true);
  //endregion

  //region toTimestamp
  /// 转毫秒时间戳, 非空
  static int toTimestamp(DateTime dateTime) => toTimestampOrNull(dateTime)!;

  /// 转毫秒时间戳, 默认为0
  static int toTimestampOrZero(DateTime? dateTime) =>
      toTimestampOrNull(dateTime) ?? 0;

  /// 转毫秒时间戳, 可空
  static int? toTimestampOrNull(DateTime? dateTime) =>
      dateTime?.millisecondsSinceEpoch;
  //endregion

  //region toTimestampWithSeconds
  /// 转秒时间戳, 非空
  static int toTimestampWithSeconds(DateTime dateTime) =>
      toTimestampWithSecondsOrNull(dateTime)!;

  /// 转秒时间戳, 默认为0
  static int toTimestampWithSecondsOrZero(DateTime? dateTime) =>
      toTimestampWithSecondsOrNull(dateTime) ?? 0;

  /// 转秒时间戳, 可空
  static int? toTimestampWithSecondsOrNull(DateTime? dateTime) =>
      dateTime != null ? dateTime.millisecondsSinceEpoch ~/ 1000 : null;
  //endregion
}
