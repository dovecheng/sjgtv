import 'package:base/l10n.dart';

@L10nKeys(
  keysPrefix: 'update_checker',
  keysDesc: '应用更新检查器（检查更新、下载安装 APK）',
)
abstract interface class UpdateCheckerL10n {
  @L10nKey(
    en: 'New version available',
    zh_CN: '发现新版本',
    zh_HK: '發現新版本',
    keyDesc: '更新对话框标题前缀',
    keyType: L10nKeyType.label,
  )
  String get newVersionTitleL10n;

  @L10nKey(
    en: 'Update content:',
    zh_CN: '更新内容:',
    zh_HK: '更新內容:',
    keyDesc: '更新说明区域标题',
    keyType: L10nKeyType.label,
  )
  String get updateContentL10n;

  @L10nKey(
    en: 'No release notes',
    zh_CN: '暂无更新说明',
    zh_HK: '暫無更新說明',
    keyDesc: '无更新说明时占位',
    keyType: L10nKeyType.message,
  )
  String get noNotesL10n;

  @L10nKey(
    en: 'Downloading',
    zh_CN: '下载中',
    zh_HK: '下載中',
    keyDesc: '下载进度前缀',
    keyType: L10nKeyType.label,
  )
  String get downloadingL10n;

  @L10nKey(
    en: 'Later',
    zh_CN: '稍后再说',
    zh_HK: '稍後再說',
    keyDesc: '稍后更新按钮',
    keyType: L10nKeyType.label,
  )
  String get laterL10n;

  @L10nKey(
    en: 'Auto update',
    zh_CN: '自动更新',
    zh_HK: '自動更新',
    keyDesc: '自动下载并安装按钮',
    keyType: L10nKeyType.label,
  )
  String get autoUpdateL10n;

  @L10nKey(
    en: 'Manual update',
    zh_CN: '手动更新',
    zh_HK: '手動更新',
    keyDesc: '跳转发布页按钮',
    keyType: L10nKeyType.label,
  )
  String get manualUpdateL10n;

  @L10nKey(
    en: 'Cancel download',
    zh_CN: '取消下载',
    zh_HK: '取消下載',
    keyDesc: '取消下载按钮',
    keyType: L10nKeyType.label,
  )
  String get cancelDownloadL10n;

  @L10nKey(
    en: 'Storage permission required to download update',
    zh_CN: '需要存储权限才能下载更新',
    zh_HK: '需要存儲權限才能下載更新',
    keyDesc: '未授予存储权限提示',
    keyType: L10nKeyType.message,
  )
  String get storageRequiredL10n;

  @L10nKey(
    en: 'Allow installing unknown apps to install update',
    zh_CN: '需要允许安装未知应用才能安装更新',
    zh_HK: '需要允許安裝未知應用才能安裝更新',
    keyDesc: '未授予安装未知应用权限提示',
    keyType: L10nKeyType.message,
  )
  String get installPermissionRequiredL10n;

  @L10nKey(
    en: 'Install failed',
    zh_CN: '安装失败',
    zh_HK: '安裝失敗',
    keyDesc: 'APK 安装失败提示',
    keyType: L10nKeyType.error,
  )
  String get installFailL10n;

  @L10nKey(
    en: 'Download failed',
    zh_CN: '下载失败',
    zh_HK: '下載失敗',
    keyDesc: '下载失败提示前缀',
    keyType: L10nKeyType.error,
  )
  String get downloadFailL10n;

  @L10nKey(
    en: 'User cancelled download',
    zh_CN: '用户取消下载',
    zh_HK: '用戶取消下載',
    keyDesc: '用户取消下载（日志/内部）',
    keyType: L10nKeyType.message,
  )
  String get userCancelDownloadL10n;
}
