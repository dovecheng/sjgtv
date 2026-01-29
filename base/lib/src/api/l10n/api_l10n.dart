import 'package:base/api.dart';
import 'package:base/l10n.dart';

@L10nKeys(
  keysPrefix: 'api',
  usedContext: {ApiResultInterceptor, ApiErrorType},
  keysDesc: '请求Api接口交互时的错误提示内容本地化',
)
abstract interface class ApiL10n {
  @L10nKey(
    en: 'SSL certificate verification failures',
    zh_CN: 'SSL安全证书验证失败',
    zh_HK: 'SSL安全證書驗證失敗',
    keyDesc:
        'An exception that happens in the handshake phase of establishing, a secure network connection, when looking up or verifying a certificate',
    keyType: L10nKeyType.error,
  )
  String get badCertificateL10n;

  @L10nKey(
    en: 'Internal server error',
    zh_CN: '服务器响应错误',
    zh_HK: '伺服器內部錯誤',
    keyDesc:
        'When the server response, but with a incorrect status, such as 404, 503...',
    keyType: L10nKeyType.error,
  )
  String get badResponseL10n;

  @L10nKey(
    en: 'Request canceled',
    zh_CN: '已取消加载',
    zh_HK: '已取消加載',
    keyDesc: 'When the request is cancelled, will throw a error with this type',
    keyType: L10nKeyType.error,
  )
  String get cancelL10n;

  @L10nKey(
    en: 'Connection host error',
    zh_CN: '服务器连接失败',
    zh_HK: '連接到伺服器时发生錯誤',
    keyDesc: 'Socket is not connected',
    keyType: L10nKeyType.error,
  )
  String get connectionErrorL10n;

  @L10nKey(
    en: 'Connection timeout, Please try again',
    zh_CN: '连接超时, 请重试',
    zh_HK: '連接超時, 請重試',
    keyDesc: 'It occurs when url is opened timeout',
    keyType: L10nKeyType.error,
  )
  String get connectionTimeoutL10n;

  @L10nKey(
    en: 'Invalid data format',
    zh_CN: '无效的数据格式',
    zh_HK: '無效的數據格式',
    keyDesc: '服务器响应数据格式错误',
    keyType: L10nKeyType.error,
  )
  String get formatErrorL10n;

  @L10nKey(
    en: 'Connection terminated during handshake',
    zh_CN: '建立安全网络连接时发生错误',
    zh_HK: '建立安全網絡連接時發生錯誤',
    keyDesc:
        'An exception that happens in the handshake phase of establishing, a secure network connection',
    keyType: L10nKeyType.error,
  )
  String get handshakeErrorL10n;

  @L10nKey(
    en: 'Invalid data format',
    zh_CN: '无效的数据格式',
    zh_HK: '無效的數據格式',
    keyDesc: '服务器响应数据格式错误',
    keyType: L10nKeyType.error,
  )
  String get parseErrorL10n;

  @L10nKey(
    en: 'Receive data timeout, Please try again',
    zh_CN: '接收数据超时, 请重试',
    zh_HK: '接收數據超時, 請重試',
    keyDesc: 'It occurs when receiving timeout',
    keyType: L10nKeyType.error,
  )
  String get receiveTimeoutL10n;

  @L10nKey(
    en: 'Send data timeout, Please try again',
    zh_CN: '发送数据超时, 请重试',
    zh_HK: '發送數據超時, 請重試',
    keyDesc: 'It occurs when url is sent timeout',
    keyType: L10nKeyType.error,
  )
  String get sendTimeoutL10n;

  @L10nKey(
    en: 'Unknown fault',
    zh_CN: '未知错误',
    zh_HK: '未知錯誤',
    keyDesc: 'Some other Error',
    keyType: L10nKeyType.error,
  )
  String get unknownErrorL10n;

  @L10nKey(
    en: 'Application Upgrade',
    zh_CN: '应用更新',
    zh_HK: '應用更新',
    keyDesc: '点击跳转应用商店的更新按钮',
    keyType: L10nKeyType.message,
  )
  String get versionUpgradeButtonL10n;

  @L10nKey(
    en: 'App must be updated to the latest version',
    zh_CN: 'App必须更新为最新版本',
    zh_HK: 'App必須更新為最新版本',
    keyDesc: '版本过低提示内容',
    keyType: L10nKeyType.message,
  )
  String get versionUpgradeMessageL10n;

  @L10nKey(
    en: 'New Version',
    zh_CN: '新版本',
    zh_HK: '新版本',
    keyDesc: '版本过低提示内容',
    keyType: L10nKeyType.message,
  )
  String get versionUpgradeTitleL10n;
}
