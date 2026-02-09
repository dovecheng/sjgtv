import 'package:logging/logging.dart';

/// 日志级别
enum LogLevel {
  all(Level('ALL', 0)),
  verbose(Level('VER', 300)),
  debug(Level('DEB', 600)),
  info(Level('INF', 800)),
  warn(Level('WAR', 900)),
  error(Level('ERR', 1000)),
  off(Level('OFF', 2000));

  final Level value;

  const LogLevel(this.value);
}
