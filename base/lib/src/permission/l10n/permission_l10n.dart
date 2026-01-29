import 'package:base/l10n.dart';

@L10nKeys(keysPrefix: 'permission', keysDesc: '权限相关的错误提示内容本地化')
abstract interface class PermissionL10n {
  @L10nKey(
    en: 'Camera access is not enabled, please grant camera access',
    zh_CN: '未启用相机访问，请授予相机访问权限',
    zh_HK: '未啟用相機訪問，請授予相機存取權限',
    keyDesc: '请在设置中打开相机权限',
    keyType: L10nKeyType.label,
  )
  String get cameraDeniedL10n;

  @L10nKey(
    en: 'App is unable to access photo album. Please grant access to photo album',
    zh_CN: '应用无法访问相册，请授予访问相册的权限',
    zh_HK: '應用無法訪問相冊， 請授予訪問相冊的權限',
    keyDesc: '无法从相册获取图片。请在设置中打开相册相关权限',
    keyType: L10nKeyType.label,
  )
  String get photosDeniedL10n;

  /// 存储权限
  @L10nKey(
    en: 'Storage permission is required to access files',
    zh_CN: '需要存储权限才能访问文件',
    zh_HK: '需要存儲權限才能訪問文件',
    keyDesc: '需要存儲權限才能訪問文件',
    keyType: L10nKeyType.label,
  )
  String get storageDeniedL10n;

}
