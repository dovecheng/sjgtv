import 'dart:convert';
import 'dart:developer' as dev;

import 'package:base/env.dart';
import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

/// 控制台日志输出
///
/// * [message] 日志内容
/// * [time] 记录时间
/// * [name] 记录器名称
/// * [error] 异常捕获
/// * [stackTrace] 堆栈跟踪
/// * [level] 日志级别
void consoleLog(
  String message, {
  DateTime? time,
  String? name,
  Object? error,
  StackTrace? stackTrace,
  Level level = Level.ALL,
}) {
  if (kReleaseMode) {
    return;
  }

  time ??= DateTime.now();

  if (stackTrace == null && error is Error) {
    stackTrace = error.stackTrace;
  }

  Iterable<String> lines = LineSplitter.split(
    [
      message,
      if (error != null) ...[error.runtimeType, error],
      if (stackTrace != null) Trace.format(stackTrace),
    ].join('\n'),
  );

  String prefix = <String?>[
    time.toString().padRight(23).substring(11, 23),
    name,
  ].where((String? e) => e != null).map((String? e) => '[$e] ').join();

  String levelName = level.name;
  if (levelName.length < 3) {
    levelName = levelName.padLeft(3);
  } else if (levelName.length > 3) {
    levelName = levelName.substring(0, 3);
  }

  message = prefix + lines.join('\n');

  // dev.log 仅在有调试连接时可见（debug 模式）；profile/release 用 print 保证控制台能看到
  if (kIsApp && kDebugMode) {
    dev.log(message, name: levelName);
  } else {
    // ignore: avoid_print
    print('[$levelName] $message');
  }
}
