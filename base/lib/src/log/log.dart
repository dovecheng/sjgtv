import 'dart:async';

import 'package:base/env.dart';
import 'package:base/log.dart';
import 'package:logging/logging.dart';
import 'package:meta/meta.dart';
import 'package:stack_trace/stack_trace.dart';

/// 日志记录器
class Log {
  /// 缓存实例
  @visibleForTesting
  static final Map<String, Log> instances = () {
    // 初始化 全局日志级别
    Logger.root.level = kReleaseMode ? LogLevel.info.value : LogLevel.all.value;

    // 初始化 监听全局日志打印, 输出控制台
    void listenOnRecord() => Logger.root.onRecord.listen(
      (LogRecord log) => consoleLog(
        log.message,
        time: log.time,
        name: log.loggerName,
        error: log.error,
        stackTrace: log.stackTrace,
        level: log.level,
      ),
      // 重新监听
      onDone: listenOnRecord,
    );
    // 开始监听
    listenOnRecord();

    return <String, Log>{};
  }();

  /// 日志记录器
  final Logger _logger;

  /// 获取日志记录器
  factory Log(String name) =>
      instances.putIfAbsent(name, () => Log._(Logger(name)));

  /// 日志记录器
  const Log._(this._logger);

  /// log with [level]
  Future<void> _log(
    LogLevel level,
    Object? message, [
    Object? error,
    StackTrace? stackTrace,
  ]) async {
    if (!_logger.isLoggable(level.value)) {
      return;
    }

    Frame caller = Frame.caller(2);
    String callerInfo = [
      ?caller.member?.split('.').skip(1).firstOrNull,
      ?caller.line,
    ].join('_');

    try {
      Object? object = message;
      if (object is Function) {
        object = object();
      }
      if (object is Future) {
        object = await object;
      }

      _logger.log(
        level.value,
        [callerInfo, ?object].join(': '),
        error,
        stackTrace,
      );
      // consoleLog(
      //   [callerInfo, ?object].join(': '),
      //   name: _logger.name,
      //   error: error,
      //   stackTrace: stackTrace,
      //   level: level.value,
      // );
    } catch (e, s) {
      consoleLog(
        [callerInfo, ?message].join(': '),
        name: _logger.name,
        error: e,
        stackTrace: s,
        level: LogLevel.off.value,
      );
    }
  }

  /// verbose log
  Future<void> v(
    Object? message, [
    Object? error,
    StackTrace? stackTrace,
  ]) async => _log(LogLevel.verbose, message, error, stackTrace);

  /// debug log
  Future<void> d(
    Object? message, [
    Object? error,
    StackTrace? stackTrace,
  ]) async => _log(LogLevel.debug, message, error, stackTrace);

  /// info log
  Future<void> i(
    Object? message, [
    Object? error,
    StackTrace? stackTrace,
  ]) async => _log(LogLevel.info, message, error, stackTrace);

  /// warn log
  Future<void> w(
    Object? message, [
    Object? error,
    StackTrace? stackTrace,
  ]) async => _log(LogLevel.warn, message, error, stackTrace);

  /// error log
  Future<void> e(
    Object? message, [
    Object? error,
    StackTrace? stackTrace,
  ]) async => _log(LogLevel.error, message, error, stackTrace);

  /// log with [level]
  Future<void> log(
    LogLevel level,
    Object? message, [
    Object? error,
    StackTrace? stackTrace,
  ]) async => _log(level, message, error, stackTrace);
}
