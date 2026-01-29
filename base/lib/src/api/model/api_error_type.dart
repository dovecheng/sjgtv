import 'dart:io';

import 'package:base/gen/l10n.gen.dart';
import 'package:dio/dio.dart';

/// Api错误类型
///
/// see [DioExceptionType]
enum ApiErrorType {
  /// Default value used when an unsupported error type occurs.
  /// 出现不支持的错误类型时使用的缺省值。
  unknownError(L10n.api_unknown_error),

  /// It occurs when url is opened fault.
  /// 当打开连接错误时发生。
  connectionError(L10n.api_connection_error),

  /// Connection terminated during handshake.
  /// 建立安全网络连接时发生错误。
  handshakeError(L10n.api_handshake_error),

  /// SSL certificate verification failures.
  /// SSL安全证书验证失败。
  badCertificate(L10n.api_bad_certificate),

  /// It occurs when url is opened timeout.
  /// 当打开连接超时时发生。
  connectionTimeout(L10n.api_connection_timeout),

  /// It occurs when url is sent timeout.
  /// 当超时发送时发生。
  sendTimeout(L10n.api_send_timeout),

  /// It occurs when receiving timeout.
  /// 当接收超时时发生。
  receiveTimeout(L10n.api_receive_timeout),

  /// When the server response, but with a incorrect status, such as 404, 503...
  /// 当服务器响应时，却带有不正确的状态，如404,503…
  badResponse(L10n.api_bad_response),

  /// When the request is cancelled, dio will throw a error with this type.
  /// 当请求被取消时，dio将抛出此类型的错误。
  cancel(L10n.api_cancel),

  /// When the server returns an invalid data format.
  /// 当服务器返回无效数据格式时。
  formatError(L10n.api_format_error),

  /// When the server returns data by is parsed fault.
  /// 当服务器返回的数据解析出错时。
  parseError(L10n.api_parse_error);

  final L10n l10n;

  const ApiErrorType(this.l10n);

  static ApiErrorType byDioError(DioException err) {
    // 解析错误类型和异常类型
    switch (err.type) {
      // SSL安全证书验证失败
      case DioExceptionType.badCertificate:
        return ApiErrorType.badCertificate;

      // 当打开连接错误时发生
      case DioExceptionType.connectionError:
        return ApiErrorType.connectionError;

      // 当打开连接超时时发生
      case DioExceptionType.connectionTimeout:
        return ApiErrorType.connectionTimeout;

      // 当超时发送时发生
      case DioExceptionType.sendTimeout:
        return ApiErrorType.sendTimeout;

      // 当接收超时时发生
      case DioExceptionType.receiveTimeout:
        return ApiErrorType.receiveTimeout;

      // 当服务器响应时，却带有不正确的状态，如404,503…
      case DioExceptionType.badResponse:
        return ApiErrorType.badResponse;

      // 当请求被取消时，dio将抛出此类型的错误。
      case DioExceptionType.cancel:
        return ApiErrorType.cancel;

      // 出现不支持的错误类型时使用的缺省值
      case DioExceptionType.unknown:
        return byError(err.error);
    }
  }

  static ApiErrorType byError(Object? error) {
    if (error is SocketException) {
      if (error.osError?.errorCode == 110) {
        // 当打开连接超时时发生
        return ApiErrorType.connectionTimeout;
      } else {
        // 服务器连接失败
        return ApiErrorType.connectionError;
      }
    } else if (error is HandshakeException) {
      // 建立安全网络连接时发生错误
      return ApiErrorType.handshakeError;
    } else if (error is CertificateException) {
      // SSL安全证书验证失败
      return ApiErrorType.badCertificate;
    } else if (error is HttpException) {
      // 当服务器响应时，却带有不正确的状态，如404,503…
      return ApiErrorType.badResponse;
    } else if (error is FormatException) {
      // 返回数据格式不正确
      return ApiErrorType.formatError;
    }
    return ApiErrorType.unknownError;
  }
}
