import 'package:logging/logging.dart';

/// 日志级别扩展
extension LogLevelExt on Level {
  /// 获取标准级别名称
  ///
  /// 将自定义的日志级别名称映射为标准级别名称，用于与 VictoriaLogs 等日志系统兼容
  /// - VER (VERBOSE) → TRACE
  /// - DEB (DEBUG) → DEBUG
  /// - INF (INFO) → INFO
  /// - WAR (WARN) → WARN
  /// - ERR (ERROR) → ERROR
  /// - 其他级别保持原样
  String get standardName => switch (name) {
    'VER' => 'TRACE',
    'DEB' => 'DEBUG',
    'INF' => 'INFO',
    'WAR' => 'WARN',
    'ERR' => 'ERROR',
    _ => name,
  };
}
