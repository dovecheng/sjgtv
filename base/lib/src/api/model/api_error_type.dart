import 'dart:io';

import 'package:base/app.dart';
import 'package:base/l10n.dart';
import 'package:dio/dio.dart';

/// Api错误类型
///
/// see [DioExceptionType]
enum ApiErrorType {
  /// Default value used when an unsupported error type occurs.
  /// 出现不支持的错误类型时使用的缺省值。
  unknownError,

  /// It occurs when url is opened fault.
  /// 当打开连接错误时发生。
  connectionError,

  /// Connection terminated during handshake.
  /// 建立安全网络连接时发生错误。
  handshakeError,

  /// SSL certificate verification failures.
  /// SSL安全证书验证失败。
  badCertificate,

  /// It occurs when url is opened timeout.
  /// 当打开连接超时时发生。
  connectionTimeout,

  /// It occurs when url is sent timeout.
  /// 当超时发送时发生。
  sendTimeout,

  /// It occurs when receiving timeout.
  /// 当接收超时时发生。
  receiveTimeout,

  /// When the server response, but with a incorrect status, such as 404, 503...
  /// 当服务器响应时，却带有不正确的状态，如404,503…
  badResponse,

  /// When the request is cancelled, dio will throw a error with this type.
  /// 当请求被取消时，dio将抛出此类型的错误。
  cancel,

  /// When the server returns an invalid data format.
  /// 当服务器返回无效数据格式时。
  formatError,

  /// When the server returns data by is parsed fault.
  /// 当服务器返回的数据解析出错时。
  parseError;

  /// 取本地化文案（基于 [AppNavigator.context]）。
  String get message {
    final BaseLocalizations l10n = BaseLocalizations.of(AppNavigator.context);
    return switch (this) {
      ApiErrorType.unknownError => l10n.apiUnknownError,
      ApiErrorType.connectionError => l10n.apiConnectionError,
      ApiErrorType.handshakeError => l10n.apiHandshakeError,
      ApiErrorType.badCertificate => l10n.apiBadCertificate,
      ApiErrorType.connectionTimeout => l10n.apiConnectionTimeout,
      ApiErrorType.sendTimeout => l10n.apiSendTimeout,
      ApiErrorType.receiveTimeout => l10n.apiReceiveTimeout,
      ApiErrorType.badResponse => l10n.apiBadResponse,
      ApiErrorType.cancel => l10n.apiCancel,
      ApiErrorType.formatError => l10n.apiFormatError,
      ApiErrorType.parseError => l10n.apiParseError,
    };
  }

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
