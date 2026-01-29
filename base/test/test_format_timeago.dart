import 'package:base/converter.dart';
import 'package:base/log.dart';
import 'package:base/l10n.dart';
import 'package:timeago/timeago.dart' as timeago;

void main() {
  Log log = Log('test');
  DateTime dateTime = DateTimeConverter.toDateTime('2024-10-17 12:21:02');

  timeago.setLocaleMessages('zh_CN', ZhCnMessages());
  timeago.setDefaultLocale('zh_CN');

  log.d(() => '2024-10-17 12:21:02');
  log.d(() => dateTime.formatTimeAgo());
  log.d(() => '${DateTime.now()}');
  log.d(() => DateTime.now().formatTimeAgo());
}
