import 'package:quiver/time.dart' as quiver;

/// 默认一周的第一天是周日
const int _defaultFirstDayOfWeek = DateTime.sunday;

/// 日期单位
enum DateTimeUnit {
  year,
  month,
  day,
  hour,
  minute,
  second,
  millisecond,
  microsecond,
}

extension DateTimeExt on DateTime {
  /// 是否闰年
  bool get isLeapYear => quiver.isLeapYear(year);

  /// 年总天数
  int get totalDaysInYear => isLeapYear ? 366 : 365;

  /// 月总天数
  int get totalDaysInMonth => quiver.daysInMonth(year, month);

  /// 是否月初
  bool get isFirstDayOfMonth => day == 1;

  /// 是否月末
  bool get isLastDayOfMonth => day == totalDaysInMonth;

  /// 是否周始
  bool isFirstDayOfWeek({int firstDayOfWeek = _defaultFirstDayOfWeek}) =>
      weekday == firstDayOfWeek;

  /// 是否周末
  bool isLastDayOfWeek({int firstDayOfWeek = _defaultFirstDayOfWeek}) =>
      weekday == (firstDayOfWeek + 6) % 7;

  /// 判断在同一微秒内

  bool isSameMicroseconds(DateTime dt) {
    assert(isSameTimeZoneOffset(dt));
    return microsecondsSinceEpoch == dt.microsecondsSinceEpoch;
  }

  /// 判断在同一毫秒内
  bool isSameMillisecond(DateTime dt) {
    assert(isSameTimeZoneOffset(dt));
    return millisecondsSinceEpoch == dt.millisecondsSinceEpoch;
  }

  /// 判断在同一秒钟内
  bool isSameSecond(DateTime dt) {
    assert(isSameTimeZoneOffset(dt));
    return year == dt.year &&
        month == dt.month &&
        day == dt.day &&
        hour == dt.hour &&
        minute == dt.minute &&
        second == dt.second;
  }

  /// 判断在同一分钟内
  bool isSameMinute(DateTime dt) {
    assert(isSameTimeZoneOffset(dt));
    return year == dt.year &&
        month == dt.month &&
        day == dt.day &&
        hour == dt.hour &&
        minute == dt.minute;
  }

  /// 判断在同一小时内
  bool isSameHour(DateTime dt) {
    assert(isSameTimeZoneOffset(dt));
    return year == dt.year &&
        month == dt.month &&
        day == dt.day &&
        hour == dt.hour;
  }

  /// 判断在同一天内
  bool isSameDay(DateTime dt) {
    assert(isSameTimeZoneOffset(dt));
    return year == dt.year && month == dt.month && day == dt.day;
  }

  /// 判断在同一周内
  bool isSameWeek(DateTime dt, {int firstDayOfWeek = _defaultFirstDayOfWeek}) {
    assert(isSameTimeZoneOffset(dt));
    return this
        .firstDayOfWeek(firstDayOfWeek: firstDayOfWeek)
        .isSameDay(dt.firstDayOfWeek(firstDayOfWeek: firstDayOfWeek));
  }

  /// 判断在同一月内
  bool isSameMonth(DateTime dt) {
    assert(isSameTimeZoneOffset(dt));
    return year == dt.year && month == dt.month;
  }

  /// 判断在同一年内
  bool isSameYear(DateTime dt) {
    assert(isSameTimeZoneOffset(dt));
    return year == dt.year;
  }

  /// 检查是否相同时区
  bool isSameTimeZoneOffset(DateTime dt) => timeZoneOffset == dt.timeZoneOffset;

  /// 前1天
  DateTime prevDays([int value = 1]) =>
      apply(year: year, month: month, day: day - value);

  /// 后1天
  DateTime nextDays([int value = 1]) =>
      apply(year: year, month: month, day: day + value);

  /// 前一周
  DateTime prevWeeks([int value = 1]) =>
      apply(year: year, month: month, day: day - 7 * value);

  /// 后一周
  DateTime nextWeeks([int value = 1]) =>
      apply(year: year, month: month, day: day + 7 * value);

  /// 前1月
  DateTime prevMonths([int value = 1]) =>
      apply(year: year, month: month - value);

  /// 后1月
  DateTime nextMonths([int value = 1]) =>
      apply(year: year, month: month + value);

  /// 前1年
  DateTime prevYears([int value = 1]) => apply(year: year - value);

  /// 后1年
  DateTime nextYears([int value = 1]) => apply(year: year + value);

  /// 周始
  ///
  /// [first] 一周的第一天，default: [_defaultFirstDayOfWeek]
  DateTime firstDayOfWeek({int firstDayOfWeek = _defaultFirstDayOfWeek}) {
    int offset = firstDayOfWeek;
    return apply(
      year: year,
      month: month,
      day: day - (offset > weekday ? 7 - offset + weekday : offset - weekday),
    );
  }

  /// 周末
  ///
  /// [first] 一周的第一天，default: [_defaultFirstDayOfWeek]
  DateTime lastDayOfWeek({int firstDayOfWeek = _defaultFirstDayOfWeek}) {
    int offset = (firstDayOfWeek + 6) % 7;
    return apply(
      year: year,
      month: month,
      day: day + (offset >= weekday ? offset - weekday : 7 + offset - weekday),
    );
  }

  /// 月初
  DateTime get firstDayOfMonth => apply(year: year, month: month);

  /// 月末
  DateTime get lastDayOfMonth =>
      apply(year: year, month: month + 1).subtract(quiver.aDay);

  /// 年初
  DateTime get firstDayOfYear => apply(year: year);

  /// 年末
  DateTime get lastDayOfYear => apply(year: year + 1).subtract(quiver.aDay);

  /// 日期取最小值
  ///
  /// [unit] 单位 默认 n年n月n日 0时0分0秒0毫秒0微秒
  DateTime floor({DateTimeUnit unit = DateTimeUnit.day}) => switch (unit) {
    DateTimeUnit.year => apply(year: year),
    DateTimeUnit.month => apply(year: year, month: month),
    DateTimeUnit.day => apply(year: year, month: month, day: day),
    DateTimeUnit.hour => apply(year: year, month: month, day: day, hour: hour),
    DateTimeUnit.minute => apply(
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
    ),
    DateTimeUnit.second => apply(
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second,
    ),
    DateTimeUnit.millisecond => apply(
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second,
      millisecond: millisecond,
    ),
    DateTimeUnit.microsecond => this,
  };

  /// 日期取最大值
  ///
  /// [unit] 单位 默认 n年n月n日 23时59分59秒999毫秒999微秒
  DateTime ceil({DateTimeUnit unit = DateTimeUnit.day}) => switch (unit) {
    DateTimeUnit.year => apply(year: year + 1).subtract(quiver.aMicrosecond),
    DateTimeUnit.month => apply(
      year: year,
      month: month + 1,
    ).subtract(quiver.aMicrosecond),
    DateTimeUnit.day => apply(
      year: year,
      month: month,
      day: day + 1,
    ).subtract(quiver.aMicrosecond),
    DateTimeUnit.hour => apply(
      year: year,
      month: month,
      day: day,
      hour: hour + 1,
    ).subtract(quiver.aMicrosecond),
    DateTimeUnit.minute => apply(
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute + 1,
    ).subtract(quiver.aMicrosecond),
    DateTimeUnit.second => apply(
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second + 1,
    ).subtract(quiver.aMicrosecond),
    DateTimeUnit.millisecond => apply(
      year: year,
      month: month,
      day: day,
      hour: hour,
      minute: minute,
      second: second,
      millisecond: millisecond + 1,
    ).subtract(quiver.aMicrosecond),
    DateTimeUnit.microsecond => this,
  };

  /// 计算某个时间与当天0时0分的差值
  ///
  /// 返回：时间与当天0时0分0秒的差值（Duration）
  ///
  /// 示例：
  /// - 输入：2026/01/08 16:30:45
  /// - 返回：16小时30分45秒的 Duration
  Duration get differenceFromMidnight {
    // 获取当天的0时0分0秒
    DateTime midnight = floor();

    // 计算差值
    return difference(midnight);
  }

  /// 日期范围集合, 支持从大到小
  List<DateTime> daysInRange(DateTime end) {
    int diff = end.difference(this).inDays;
    int step = diff > 0 ? 1 : -1;
    int length = diff != 0 ? diff + step : 0;
    return [
      for (int i = 0; i != length; i += step)
        apply(year: year, month: month, day: day + i),
    ];
  }

  /// 获取一周内每天的数组
  ///
  /// [first] 一周的第一天, default: [_defaultFirstDayOfWeek]
  List<DateTime> daysInWeek({int firstDayOfWeek = _defaultFirstDayOfWeek}) =>
      this
          .firstDayOfWeek(firstDayOfWeek: firstDayOfWeek)
          .daysInRange(lastDayOfWeek(firstDayOfWeek: firstDayOfWeek));

  /// 获取一个月内每天的数组
  List<DateTime> get daysInMonth => firstDayOfMonth.daysInRange(lastDayOfMonth);

  /// 获取一年内每天的数组
  List<DateTime> get daysInYear => firstDayOfYear.daysInRange(lastDayOfYear);

  /// 时间戳 毫秒
  int get timestampByMillisecond => millisecondsSinceEpoch;

  /// 时间戳 秒
  int get timestampBySecond => timestampByMillisecond ~/ 1000;

  /// [DateTime] 构造方法
  ///
  /// if this is utc use [DateTime.utc] else [DateTime.new]
  DateTime apply({
    int year = 0,
    int month = 1,
    int day = 1,
    int hour = 0,
    int minute = 0,
    int second = 0,
    int millisecond = 0,
    int microsecond = 0,
  }) => (isUtc ? DateTime.utc : DateTime.new)(
    year,
    month,
    day,
    hour,
    minute,
    second,
    millisecond,
    microsecond,
  );
}
