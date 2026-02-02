// GENERATED CODE BY 2026-02-02 02:15:48 - DO NOT MODIFY BY HAND
// ignore_for_file: constant_identifier_names, prefer_single_quotes

import 'package:base/l10n.dart';

/// L10n keys and translations
///
/// Has 11 keys
enum L10n with L10nMixin {
  /// key: api_bad_certificate
  ///
  /// en: SSL certificate verification failures
  ///
  /// zh_CN: SSL安全证书验证失败
  ///
  /// zh_HK: SSL安全證書驗證失敗
  ///
  /// keyDesc: An exception that happens in the handshake phase of establishing, a secure network connection, when looking up or verifying a certificate
  ///
  /// keyType: error
  api_bad_certificate,

  /// key: api_bad_response
  ///
  /// en: Internal server error
  ///
  /// zh_CN: 服务器响应错误
  ///
  /// zh_HK: 伺服器內部錯誤
  ///
  /// keyDesc: When the server response, but with a incorrect status, such as 404, 503...
  ///
  /// keyType: error
  api_bad_response,

  /// key: api_cancel
  ///
  /// en: Request canceled
  ///
  /// zh_CN: 已取消加载
  ///
  /// zh_HK: 已取消加載
  ///
  /// keyDesc: When the request is cancelled, will throw a error with this type
  ///
  /// keyType: error
  api_cancel,

  /// key: api_connection_error
  ///
  /// en: Connection host error
  ///
  /// zh_CN: 服务器连接失败
  ///
  /// zh_HK: 連接到伺服器时发生錯誤
  ///
  /// keyDesc: Socket is not connected
  ///
  /// keyType: error
  api_connection_error,

  /// key: api_connection_timeout
  ///
  /// en: Connection timeout, Please try again
  ///
  /// zh_CN: 连接超时, 请重试
  ///
  /// zh_HK: 連接超時, 請重試
  ///
  /// keyDesc: It occurs when url is opened timeout
  ///
  /// keyType: error
  api_connection_timeout,

  /// key: api_format_error
  ///
  /// en: Invalid data format
  ///
  /// zh_CN: 无效的数据格式
  ///
  /// zh_HK: 無效的數據格式
  ///
  /// keyDesc: 服务器响应数据格式错误
  ///
  /// keyType: error
  api_format_error,

  /// key: api_handshake_error
  ///
  /// en: Connection terminated during handshake
  ///
  /// zh_CN: 建立安全网络连接时发生错误
  ///
  /// zh_HK: 建立安全網絡連接時發生錯誤
  ///
  /// keyDesc: An exception that happens in the handshake phase of establishing, a secure network connection
  ///
  /// keyType: error
  api_handshake_error,

  /// key: api_parse_error
  ///
  /// en: Invalid data format
  ///
  /// zh_CN: 无效的数据格式
  ///
  /// zh_HK: 無效的數據格式
  ///
  /// keyDesc: 服务器响应数据格式错误
  ///
  /// keyType: error
  api_parse_error,

  /// key: api_receive_timeout
  ///
  /// en: Receive data timeout, Please try again
  ///
  /// zh_CN: 接收数据超时, 请重试
  ///
  /// zh_HK: 接收數據超時, 請重試
  ///
  /// keyDesc: It occurs when receiving timeout
  ///
  /// keyType: error
  api_receive_timeout,

  /// key: api_send_timeout
  ///
  /// en: Send data timeout, Please try again
  ///
  /// zh_CN: 发送数据超时, 请重试
  ///
  /// zh_HK: 發送數據超時, 請重試
  ///
  /// keyDesc: It occurs when url is sent timeout
  ///
  /// keyType: error
  api_send_timeout,

  /// key: api_unknown_error
  ///
  /// en: Unknown fault
  ///
  /// zh_CN: 未知错误
  ///
  /// zh_HK: 未知錯誤
  ///
  /// keyDesc: Some other Error
  ///
  /// keyType: error
  api_unknown_error;

  static final Set<L10nTranslationModel> translations = <L10nTranslationModel>{
    L10nTranslationModel(
      languageTag: 'en',
      translations: const {
        'api_bad_certificate': 'SSL certificate verification failures',
        'api_bad_response': 'Internal server error',
        'api_cancel': 'Request canceled',
        'api_connection_error': 'Connection host error',
        'api_connection_timeout': 'Connection timeout, Please try again',
        'api_format_error': 'Invalid data format',
        'api_handshake_error': 'Connection terminated during handshake',
        'api_parse_error': 'Invalid data format',
        'api_receive_timeout': 'Receive data timeout, Please try again',
        'api_send_timeout': 'Send data timeout, Please try again',
        'api_unknown_error': 'Unknown fault',
      },
    ),
    L10nTranslationModel(
      languageTag: 'zh-CN',
      translations: const {
        'api_bad_certificate': 'SSL安全证书验证失败',
        'api_bad_response': '服务器响应错误',
        'api_cancel': '已取消加载',
        'api_connection_error': '服务器连接失败',
        'api_connection_timeout': '连接超时, 请重试',
        'api_format_error': '无效的数据格式',
        'api_handshake_error': '建立安全网络连接时发生错误',
        'api_parse_error': '无效的数据格式',
        'api_receive_timeout': '接收数据超时, 请重试',
        'api_send_timeout': '发送数据超时, 请重试',
        'api_unknown_error': '未知错误',
      },
    ),
    L10nTranslationModel(
      languageTag: 'zh-HK',
      translations: const {
        'api_bad_certificate': 'SSL安全證書驗證失敗',
        'api_bad_response': '伺服器內部錯誤',
        'api_cancel': '已取消加載',
        'api_connection_error': '連接到伺服器时发生錯誤',
        'api_connection_timeout': '連接超時, 請重試',
        'api_format_error': '無效的數據格式',
        'api_handshake_error': '建立安全網絡連接時發生錯誤',
        'api_parse_error': '無效的數據格式',
        'api_receive_timeout': '接收數據超時, 請重試',
        'api_send_timeout': '發送數據超時, 請重試',
        'api_unknown_error': '未知錯誤',
      },
    ),
  };
}