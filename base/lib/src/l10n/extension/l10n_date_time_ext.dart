import 'package:intl/intl.dart';
import 'package:timeago/timeago.dart' as timeago;

import 'package:base/l10n.dart';
import 'package:base/provider.dart';

extension L10nDateTimeFormatExt on DateTime {
  /// 本地时区偏移分钟数
  static final int localTimeZoneOffsetInMinutes =
      DateTime.now().timeZoneOffset.inMinutes;

  /// 日期格式化
  ///
  /// [style] 格式化的样式
  ///
  /// [locale] 本地化
  String format({String style = 'yyyy/MM/dd HH:mm', bool useLocale = false}) =>
      DateFormat(
        style,
        useLocale
            ? $ref.read(l10nLanguageProvider).value?.$1.languageTag
            : null,
      ).format(this);

  /// 日期格式化
  ///
  /// [style] 格式化的样式
  ///
  /// [timeZoneOffsetInMinutes] 添加指定时区偏移, 以分钟为单位
  ///
  /// [canUseLocalTimeZoneOffset] 如没有指定时区, 可以添加本地时区偏移
  ///
  /// [canAppendTimeZoneOnDiff] 如指定时区如本地时区不同时, 可以附加时区尾巴
  ///
  /// [locale] 本地化
  String formatUtc({
    String style = 'yyyy/MM/dd HH:mm',
    int? timeZoneOffsetInMinutes,
    bool? canUseLocalTimeZoneOffset,
    bool? canAppendTimeZoneOnDiff,
    bool useLocale = false,
  }) {
    DateTime dateTime = toUtc();
    canUseLocalTimeZoneOffset ??= false;
    canAppendTimeZoneOnDiff ??= !canUseLocalTimeZoneOffset;

    // 判断是否使用本地时区, 接口返回的日期都是UTC时区的
    if (canUseLocalTimeZoneOffset) {
      timeZoneOffsetInMinutes ??= localTimeZoneOffsetInMinutes;
    }

    // 增加指定时区偏移
    if (timeZoneOffsetInMinutes != null && timeZoneOffsetInMinutes != 0) {
      dateTime = add(Duration(minutes: timeZoneOffsetInMinutes));
    }

    // 日期格式化
    String formatted = dateTime.format(style: style, useLocale: useLocale);

    // 判断是否需要处理时区差异
    if (canAppendTimeZoneOnDiff &&
        timeZoneOffsetInMinutes != null &&
        timeZoneOffsetInMinutes != localTimeZoneOffsetInMinutes) {
      int abs = timeZoneOffsetInMinutes.abs();
      int hour = abs ~/ 60;
      int minute = abs % 60;
      formatted +=
          ' (${timeZoneOffsetInMinutes > 0 ? '+' : '-'}$hour:${'$minute'.padLeft(2, '0')})';
    }

    return formatted;
  }

  /// Formats provided [date] to a fuzzy time like 'a moment ago'
  ///
  /// - If [locale] is passed will look for message for that locale, if you want
  ///   to add or override locales use [setLocaleMessages]. Defaults to 'en'
  /// - If [clock] is passed this will be the point of reference for calculating
  ///   the elapsed time. Defaults to DateTime.now()
  /// - If [allowFromNow] is passed, format will use the From prefix, ie. a date
  ///   5 minutes from now in 'en' locale will display as "5 minutes from now"
  String formatTimeAgo({
    String? locale,
    DateTime? clock,
    bool allowFromNow = false,
  }) => timeago.format(
    this,
    locale: locale,
    clock: clock,
    allowFromNow: allowFromNow,
  );
}
