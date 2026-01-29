// GENERATED CODE BY 2026-01-30 07:39:47 - DO NOT MODIFY BY HAND

import 'package:base/gen/l10n.gen.dart';
import 'package:base/l10n.dart';

import 'api_l10n.dart';

export 'api_l10n.dart';

/// has 14 keys
///
/// keysPrefix: api
///
/// usedContext: [ApiResultInterceptor], [ApiErrorType]
///
/// keysDesc: 请求Api接口交互时的错误提示内容本地化
mixin ApiL10nMixin implements ApiL10n {
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
  @override
  String get badCertificateL10n => badCertificateL10nEntry.value;

  String get badCertificateL10nKey => badCertificateL10nEntry.key;

  L10nMixin get badCertificateL10nEntry => L10n.api_bad_certificate;

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
  @override
  String get badResponseL10n => badResponseL10nEntry.value;

  String get badResponseL10nKey => badResponseL10nEntry.key;

  L10nMixin get badResponseL10nEntry => L10n.api_bad_response;

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
  @override
  String get cancelL10n => cancelL10nEntry.value;

  String get cancelL10nKey => cancelL10nEntry.key;

  L10nMixin get cancelL10nEntry => L10n.api_cancel;

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
  @override
  String get connectionErrorL10n => connectionErrorL10nEntry.value;

  String get connectionErrorL10nKey => connectionErrorL10nEntry.key;

  L10nMixin get connectionErrorL10nEntry => L10n.api_connection_error;

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
  @override
  String get connectionTimeoutL10n => connectionTimeoutL10nEntry.value;

  String get connectionTimeoutL10nKey => connectionTimeoutL10nEntry.key;

  L10nMixin get connectionTimeoutL10nEntry => L10n.api_connection_timeout;

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
  @override
  String get formatErrorL10n => formatErrorL10nEntry.value;

  String get formatErrorL10nKey => formatErrorL10nEntry.key;

  L10nMixin get formatErrorL10nEntry => L10n.api_format_error;

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
  @override
  String get handshakeErrorL10n => handshakeErrorL10nEntry.value;

  String get handshakeErrorL10nKey => handshakeErrorL10nEntry.key;

  L10nMixin get handshakeErrorL10nEntry => L10n.api_handshake_error;

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
  @override
  String get parseErrorL10n => parseErrorL10nEntry.value;

  String get parseErrorL10nKey => parseErrorL10nEntry.key;

  L10nMixin get parseErrorL10nEntry => L10n.api_parse_error;

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
  @override
  String get receiveTimeoutL10n => receiveTimeoutL10nEntry.value;

  String get receiveTimeoutL10nKey => receiveTimeoutL10nEntry.key;

  L10nMixin get receiveTimeoutL10nEntry => L10n.api_receive_timeout;

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
  @override
  String get sendTimeoutL10n => sendTimeoutL10nEntry.value;

  String get sendTimeoutL10nKey => sendTimeoutL10nEntry.key;

  L10nMixin get sendTimeoutL10nEntry => L10n.api_send_timeout;

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
  @override
  String get unknownErrorL10n => unknownErrorL10nEntry.value;

  String get unknownErrorL10nKey => unknownErrorL10nEntry.key;

  L10nMixin get unknownErrorL10nEntry => L10n.api_unknown_error;

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
  @override
  String get versionUpgradeButtonL10n => versionUpgradeButtonL10nEntry.value;

  String get versionUpgradeButtonL10nKey => versionUpgradeButtonL10nEntry.key;

  L10nMixin get versionUpgradeButtonL10nEntry =>
      L10n.api_version_upgrade_button;

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
  @override
  String get versionUpgradeMessageL10n => versionUpgradeMessageL10nEntry.value;

  String get versionUpgradeMessageL10nKey => versionUpgradeMessageL10nEntry.key;

  L10nMixin get versionUpgradeMessageL10nEntry =>
      L10n.api_version_upgrade_message;

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
  @override
  String get versionUpgradeTitleL10n => versionUpgradeTitleL10nEntry.value;

  String get versionUpgradeTitleL10nKey => versionUpgradeTitleL10nEntry.key;

  L10nMixin get versionUpgradeTitleL10nEntry => L10n.api_version_upgrade_title;
}