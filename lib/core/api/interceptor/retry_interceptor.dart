import 'package:dio/dio.dart';
import 'package:sjgtv/core/log/log.dart';

/// 重试拦截器
///
/// 在请求失败时自动重试，支持指数退避策略
class RetryInterceptor extends Interceptor {
  final Log log = (RetryInterceptor).log;

  /// 最大重试次数
  final int maxRetries;

  /// 重试间隔（毫秒）
  final int retryInterval;

  /// 是否重试的判断函数
  final bool Function(DioException error)? shouldRetry;

  RetryInterceptor({
    this.maxRetries = 3,
    this.retryInterval = 1000,
    this.shouldRetry,
  });

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    // 如果不应该重试，直接传递错误
    if (!_shouldRetry(err)) {
      handler.next(err);
      return;
    }

    // 获取当前重试次数
    int retryCount = err.requestOptions.extra['retryCount'] ?? 0;

    // 如果超过最大重试次数，传递错误
    if (retryCount >= maxRetries) {
      log.w(() => '请求失败，已达到最大重试次数: ${err.requestOptions.uri}');
      handler.next(err);
      return;
    }

    // 计算退避时间（指数退避）
    final delay = _calculateBackoff(retryCount);

    log.i(
      () =>
          '请求失败，将在 ${delay}ms 后进行第 ${retryCount + 1} 次重试: ${err.requestOptions.uri}',
    );

    // 等待退避时间
    await Future.delayed(Duration(milliseconds: delay));

    // 增加重试计数
    err.requestOptions.extra['retryCount'] = retryCount + 1;

    try {
      // 重新发起请求
      final response = await Dio().fetch(err.requestOptions);
      handler.resolve(response);
    } on DioException catch (e) {
      // 重试失败，继续传递错误
      handler.next(e);
    }
  }

  /// 判断是否应该重试
  bool _shouldRetry(DioException error) {
    // 如果有自定义判断函数，使用它
    if (shouldRetry != null) {
      return shouldRetry!(error);
    }

    // 默认重试逻辑
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.connectionError:
        return true;
      case DioExceptionType.badResponse:
        // 只在 5xx 错误时重试
        final statusCode = error.response?.statusCode;
        return statusCode != null && statusCode >= 500;
      default:
        return false;
    }
  }

  /// 计算退避时间（指数退避）
  int _calculateBackoff(int retryCount) {
    // 指数退避：retryInterval * (2 ^ retryCount)
    // 添加随机抖动避免惊群效应
    final baseDelay = retryInterval * (1 << retryCount);
    final jitter = (baseDelay * 0.1).toInt(); // 10% 随机抖动
    return baseDelay +
        (jitter * (DateTime.now().millisecond % 2 == 0 ? 1 : -1));
  }
}
