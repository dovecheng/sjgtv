/// 错误类型基类
abstract class Failure {
  const Failure(this.message);

  final String message;

  @override
  String toString() => message;
}

/// 网络错误
class NetworkFailure extends Failure {
  const NetworkFailure(super.message, [this.statusCode]);

  final int? statusCode;
}

/// 解析错误
class ParseFailure extends Failure {
  const ParseFailure(super.message);
}

/// 缓存错误
class CacheFailure extends Failure {
  const CacheFailure(super.message);
}

/// 服务器错误
class ServerFailure extends Failure {
  const ServerFailure(super.message, [this.statusCode]);

  final int? statusCode;
}

/// 数据库错误
class DatabaseFailure extends Failure {
  const DatabaseFailure(super.message);
}

/// 超时错误
class TimeoutFailure extends Failure {
  const TimeoutFailure([super.message = '请求超时']);
}

/// 未授权错误
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure([super.message = '未授权访问']);
}

/// 禁止访问错误
class ForbiddenFailure extends Failure {
  const ForbiddenFailure([super.message = '禁止访问']);
}

/// 未找到错误
class NotFoundFailure extends Failure {
  const NotFoundFailure([super.message = '资源未找到']);
}

/// 验证错误
class ValidationFailure extends Failure {
  const ValidationFailure(super.message);
}

/// 未知的错误
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}