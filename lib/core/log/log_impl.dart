import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:logging/logging.dart';
import 'package:stack_trace/stack_trace.dart';

import 'package:sjgtv/core/env.dart';
import 'log_level.dart';
import 'log_print.dart';

/// 日志记录器
class Log {
  /// 缓存实例
  @visibleForTesting
  static final Map<String, Log> instances = () {
    Logger.root.level = kReleaseMode ? LogLevel.info.value : LogLevel.all.value;

    void listenOnRecord() => Logger.root.onRecord.listen(
      (LogRecord log) => consoleLog(
        log.message,
        time: log.time,
        name: log.loggerName,
        error: log.error,
        stackTrace: log.stackTrace,
        level: log.level,
      ),
      onDone: listenOnRecord,
    );
    listenOnRecord();
    return <String, Log>{};
  }();

  final Logger _logger;

  factory Log(String name) =>
      instances.putIfAbsent(name, () => Log._(Logger(name)));

  const Log._(this._logger);

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
      caller.member?.split('.').skip(1).firstOrNull,
      caller.line,
    ].whereType<Object>().join('_');

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
        [callerInfo, object].join(': '),
        error,
        stackTrace,
      );
    } catch (e, s) {
      consoleLog(
        [callerInfo, message].join(': '),
        name: _logger.name,
        error: e,
        stackTrace: s,
        level: LogLevel.off.value,
      );
    }
  }

  Future<void> v(
    Object? message, [
    Object? error,
    StackTrace? stackTrace,
  ]) async => _log(LogLevel.verbose, message, error, stackTrace);

  Future<void> d(
    Object? message, [
    Object? error,
    StackTrace? stackTrace,
  ]) async => _log(LogLevel.debug, message, error, stackTrace);

  Future<void> i(
    Object? message, [
    Object? error,
    StackTrace? stackTrace,
  ]) async => _log(LogLevel.info, message, error, stackTrace);

  Future<void> w(
    Object? message, [
    Object? error,
    StackTrace? stackTrace,
  ]) async => _log(LogLevel.warn, message, error, stackTrace);

  Future<void> e(
    Object? message, [
    Object? error,
    StackTrace? stackTrace,
  ]) async => _log(LogLevel.error, message, error, stackTrace);

  Future<void> log(
    LogLevel level,
    Object? message, [
    Object? error,
    StackTrace? stackTrace,
  ]) async => _log(level, message, error, stackTrace);
}
