import 'package:base/base.dart';

/// 单例
abstract class DateTimeManager {
  /// 展示时间(+1天、+2天,-1天、-2天)
  static String? formatDayDiffAndTime({
    DateTime? standardDateTime,
    int? standardTimeZone,
    DateTime? dateTime,
    int? dateTimeZone,
    String? formatStyle,

    /// (+1,-1)放在前面还是后面
    bool isPrefix = true,
  }) {
    if (dateTime == null || standardDateTime == null) {
      return null;
    }

    if (standardDateTime.isUtc) {
      standardTimeZone ??= 0;
    } else {
      standardTimeZone ??= standardDateTime.timeZoneOffset.inMinutes;
    }

    if (dateTime.isUtc) {
      dateTimeZone ??= 0;
    } else {
      dateTimeZone ??= dateTime.timeZoneOffset.inMinutes;
    }

    // MARK(wy): 2025-04-23 这里用于展示
    // format后的时间
    String msg = dateTime.toUtc().formatUtc(
      timeZoneOffsetInMinutes: dateTimeZone,
      style: formatStyle ?? 'HH:mm',
    );
    if (msg.isEmpty) {
      return null;
    }

    // MARK(wy): 2025-04-23 一下用于决定前缀

    // 决定是否+1、+2
    int difDay = 0;

    DateTime newDateTimeUtc = dateTime.toUtc().add(
      Duration(minutes: dateTimeZone),
    );
    DateTime newStandardDateTimeUtc = standardDateTime.toUtc().add(
      Duration(minutes: standardTimeZone),
    );

    bool isSameDay = newDateTimeUtc.isSameDay(newStandardDateTimeUtc);

    if (newStandardDateTimeUtc.isBefore(newDateTimeUtc) && !isSameDay) {
      difDay = newDateTimeUtc
          .floor()
          .difference(newStandardDateTimeUtc.floor())
          .inDays;
      if (difDay != 0) {
        return isPrefix ? '(+$difDay)$msg' : '$msg(+$difDay)';
      }
    } else if (newDateTimeUtc.isBefore(newStandardDateTimeUtc) && !isSameDay) {
      difDay = newDateTimeUtc
          .floor()
          .difference(newStandardDateTimeUtc.floor())
          .inDays;

      if (difDay != 0) {
        return isPrefix ? '($difDay)$msg' : '$msg($difDay)';
      }
    }

    return msg;
  }
}
