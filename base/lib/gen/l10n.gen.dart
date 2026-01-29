// GENERATED CODE BY 2026-01-30 07:39:47 - DO NOT MODIFY BY HAND
// ignore_for_file: constant_identifier_names, prefer_single_quotes

import 'package:base/l10n.dart';

/// L10n keys and translations
///
/// Has 17 keys
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
  api_unknown_error,

  /// key: api_version_upgrade_button
  ///
  /// en: Application Upgrade
  ///
  /// zh_CN: 应用更新
  ///
  /// zh_HK: 應用更新
  ///
  /// keyDesc: 点击跳转应用商店的更新按钮
  ///
  /// keyType: message
  api_version_upgrade_button,

  /// key: api_version_upgrade_message
  ///
  /// en: App must be updated to the latest version
  ///
  /// zh_CN: App必须更新为最新版本
  ///
  /// zh_HK: App必須更新為最新版本
  ///
  /// keyDesc: 版本过低提示内容
  ///
  /// keyType: message
  api_version_upgrade_message,

  /// key: api_version_upgrade_title
  ///
  /// en: New Version
  ///
  /// zh_CN: 新版本
  ///
  /// zh_HK: 新版本
  ///
  /// keyDesc: 版本过低提示内容
  ///
  /// keyType: message
  api_version_upgrade_title,

  /// key: permission_camera_denied
  ///
  /// en: Camera access is not enabled, please grant camera access
  ///
  /// zh_CN: 未启用相机访问，请授予相机访问权限
  ///
  /// zh_HK: 未啟用相機訪問，請授予相機存取權限
  ///
  /// keyDesc: 请在设置中打开相机权限
  ///
  /// keyType: label
  permission_camera_denied,

  /// key: permission_photos_denied
  ///
  /// en: App is unable to access photo album. Please grant access to photo album
  ///
  /// zh_CN: 应用无法访问相册，请授予访问相册的权限
  ///
  /// zh_HK: 應用無法訪問相冊， 請授予訪問相冊的權限
  ///
  /// keyDesc: 无法从相册获取图片。请在设置中打开相册相关权限
  ///
  /// keyType: label
  permission_photos_denied,

  /// key: permission_storage_denied
  ///
  /// en: Storage permission is required to access files
  ///
  /// zh_CN: 需要存储权限才能访问文件
  ///
  /// zh_HK: 需要存儲權限才能訪問文件
  ///
  /// keyDesc: 需要存儲權限才能訪問文件
  ///
  /// keyType: label
  permission_storage_denied;

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
        'api_version_upgrade_button': 'Application Upgrade',
        'api_version_upgrade_message':
            'App must be updated to the latest version',
        'api_version_upgrade_title': 'New Version',
        'permission_camera_denied':
            'Camera access is not enabled, please grant camera access',
        'permission_photos_denied':
            'App is unable to access photo album. Please grant access to photo album',
        'permission_storage_denied':
            'Storage permission is required to access files',
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
        'api_version_upgrade_button': '应用更新',
        'api_version_upgrade_message': 'App必须更新为最新版本',
        'api_version_upgrade_title': '新版本',
        'permission_camera_denied': '未启用相机访问，请授予相机访问权限',
        'permission_photos_denied': '应用无法访问相册，请授予访问相册的权限',
        'permission_storage_denied': '需要存储权限才能访问文件',
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
        'api_version_upgrade_button': '應用更新',
        'api_version_upgrade_message': 'App必須更新為最新版本',
        'api_version_upgrade_title': '新版本',
        'permission_camera_denied': '未啟用相機訪問，請授予相機存取權限',
        'permission_photos_denied': '應用無法訪問相冊， 請授予訪問相冊的權限',
        'permission_storage_denied': '需要存儲權限才能訪問文件',
      },
    ),
  };
}