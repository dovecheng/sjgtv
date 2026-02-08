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

/// 未知的错误
class UnknownFailure extends Failure {
  const UnknownFailure(super.message);
}