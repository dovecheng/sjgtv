import 'package:base/src/arch/errors/failures.dart';

/// Result 类型 - 函数式错误处理
///
/// 特性：
/// - 避免异常传播
/// - 类型安全的错误处理
/// - 支持函数式编程
class Result<T, E extends Failure> {
  const Result._({
    required this.isSuccess,
    this.value,
    this.error,
  });

  /// 创建成功结果
  factory Result.success(T value) {
    return Result._(isSuccess: true, value: value);
  }

  /// 创建失败结果
  factory Result.failure(E error) {
    return Result._(isSuccess: false, error: error);
  }

  /// 是否成功
  final bool isSuccess;

  /// 是否失败
  bool get isFailure => !isSuccess;

  /// 成功时的值
  final T? value;

  /// 失败时的错误
  final E? error;

  /// 获取值，失败时抛出异常
  T getOrThrow() {
    if (isSuccess && value != null) {
      return value as T;
    }
    throw error ?? const UnknownFailure('Unknown error');
  }

  /// 获取值，失败时返回默认值
  T getOrElse(T defaultValue) {
    if (isSuccess && value != null) {
      return value as T;
    }
    return defaultValue;
  }

  /// 映射成功值
  Result<R, E> map<R>(R Function(T value) mapper) {
    if (isSuccess && value != null) {
      try {
        return Result.success(mapper(value as T));
      } catch (e) {
        return Result.failure(error as E);
      }
    }
    return Result.failure(error as E);
  }

  /// 映射错误
  Result<T, F> mapError<F extends Failure>(F Function(E error) mapper) {
    if (isFailure && error != null) {
      try {
        return Result.failure(mapper(error as E));
      } catch (e) {
        return Result.failure(mapper(error as E));
      }
    }
    return Result.success(value as T);
  }

  /// 处理结果
  R fold<R>(R Function(E error) onFailure, R Function(T value) onSuccess) {
    if (isSuccess && value != null) {
      return onSuccess(value as T);
    } else if (error != null) {
      return onFailure(error as E);
    }
    return onFailure(error as E);
  }

  /// when 方法，类似 fold 但不返回值（副作用处理）
  void when(void Function(E error) onFailure, void Function(T value) onSuccess) {
    if (isSuccess && value != null) {
      onSuccess(value as T);
    } else if (error != null) {
      onFailure(error as E);
    }
  }

  /// 成功时执行回调
  Result<T, E> onSuccess(void Function(T value) callback) {
    if (isSuccess && value != null) {
      callback(value as T);
    }
    return this;
  }

  /// 失败时执行回调
  Result<T, E> onFailure(void Function(E error) callback) {
    if (isFailure && error != null) {
      callback(error as E);
    }
    return this;
  }

  @override
  String toString() {
    if (isSuccess) {
      return 'Result.success($value)';
    } else {
      return 'Result.failure($error)';
    }
  }
}

/// FutureResult - 异步 Result 类型
typedef FutureResult<T, E extends Failure> = Future<Result<T, E>>;

/// Result 扩展方法
extension ResultExtensions<T, E extends Failure> on Result<T, E> {
  /// 链式调用
  Result<R, E> then<R>(Result<R, E> Function(T value) fn) {
    return fold(
      (error) => Result.failure(error),
      (value) => fn(value),
    );
  }
}