// GENERATED CODE BY 2026-02-02 22:54:16 - DO NOT MODIFY BY HAND

import 'package:base/l10n.dart';
import 'package:sjgtv/gen/l10n.gen.dart';

import 'update_checker_l10n.dart';

export 'update_checker_l10n.dart';

/// has 13 keys
///
/// keysPrefix: update_checker
///
/// usedContext:
///
/// keysDesc: 应用更新检查器（检查更新、下载安装 APK）
mixin UpdateCheckerL10nMixin implements UpdateCheckerL10n {
  /// key: update_checker_new_version_title
  ///
  /// en: New version available
  ///
  /// zh_CN: 发现新版本
  ///
  /// zh_HK: 發現新版本
  ///
  /// keyDesc: 更新对话框标题前缀
  ///
  /// keyType: label
  @override
  String get newVersionTitleL10n => newVersionTitleL10nEntry.value;

  String get newVersionTitleL10nKey => newVersionTitleL10nEntry.key;

  L10nMixin get newVersionTitleL10nEntry =>
      L10n.update_checker_new_version_title;

  /// key: update_checker_update_content
  ///
  /// en: Update content:
  ///
  /// zh_CN: 更新内容:
  ///
  /// zh_HK: 更新內容:
  ///
  /// keyDesc: 更新说明区域标题
  ///
  /// keyType: label
  @override
  String get updateContentL10n => updateContentL10nEntry.value;

  String get updateContentL10nKey => updateContentL10nEntry.key;

  L10nMixin get updateContentL10nEntry => L10n.update_checker_update_content;

  /// key: update_checker_no_notes
  ///
  /// en: No release notes
  ///
  /// zh_CN: 暂无更新说明
  ///
  /// zh_HK: 暫無更新說明
  ///
  /// keyDesc: 无更新说明时占位
  ///
  /// keyType: message
  @override
  String get noNotesL10n => noNotesL10nEntry.value;

  String get noNotesL10nKey => noNotesL10nEntry.key;

  L10nMixin get noNotesL10nEntry => L10n.update_checker_no_notes;

  /// key: update_checker_downloading
  ///
  /// en: Downloading
  ///
  /// zh_CN: 下载中
  ///
  /// zh_HK: 下載中
  ///
  /// keyDesc: 下载进度前缀
  ///
  /// keyType: label
  @override
  String get downloadingL10n => downloadingL10nEntry.value;

  String get downloadingL10nKey => downloadingL10nEntry.key;

  L10nMixin get downloadingL10nEntry => L10n.update_checker_downloading;

  /// key: update_checker_later
  ///
  /// en: Later
  ///
  /// zh_CN: 稍后再说
  ///
  /// zh_HK: 稍後再說
  ///
  /// keyDesc: 稍后更新按钮
  ///
  /// keyType: label
  @override
  String get laterL10n => laterL10nEntry.value;

  String get laterL10nKey => laterL10nEntry.key;

  L10nMixin get laterL10nEntry => L10n.update_checker_later;

  /// key: update_checker_auto_update
  ///
  /// en: Auto update
  ///
  /// zh_CN: 自动更新
  ///
  /// zh_HK: 自動更新
  ///
  /// keyDesc: 自动下载并安装按钮
  ///
  /// keyType: label
  @override
  String get autoUpdateL10n => autoUpdateL10nEntry.value;

  String get autoUpdateL10nKey => autoUpdateL10nEntry.key;

  L10nMixin get autoUpdateL10nEntry => L10n.update_checker_auto_update;

  /// key: update_checker_manual_update
  ///
  /// en: Manual update
  ///
  /// zh_CN: 手动更新
  ///
  /// zh_HK: 手動更新
  ///
  /// keyDesc: 跳转发布页按钮
  ///
  /// keyType: label
  @override
  String get manualUpdateL10n => manualUpdateL10nEntry.value;

  String get manualUpdateL10nKey => manualUpdateL10nEntry.key;

  L10nMixin get manualUpdateL10nEntry => L10n.update_checker_manual_update;

  /// key: update_checker_cancel_download
  ///
  /// en: Cancel download
  ///
  /// zh_CN: 取消下载
  ///
  /// zh_HK: 取消下載
  ///
  /// keyDesc: 取消下载按钮
  ///
  /// keyType: label
  @override
  String get cancelDownloadL10n => cancelDownloadL10nEntry.value;

  String get cancelDownloadL10nKey => cancelDownloadL10nEntry.key;

  L10nMixin get cancelDownloadL10nEntry => L10n.update_checker_cancel_download;

  /// key: update_checker_storage_required
  ///
  /// en: Storage permission required to download update
  ///
  /// zh_CN: 需要存储权限才能下载更新
  ///
  /// zh_HK: 需要存儲權限才能下載更新
  ///
  /// keyDesc: 未授予存储权限提示
  ///
  /// keyType: message
  @override
  String get storageRequiredL10n => storageRequiredL10nEntry.value;

  String get storageRequiredL10nKey => storageRequiredL10nEntry.key;

  L10nMixin get storageRequiredL10nEntry =>
      L10n.update_checker_storage_required;

  /// key: update_checker_install_permission_required
  ///
  /// en: Allow installing unknown apps to install update
  ///
  /// zh_CN: 需要允许安装未知应用才能安装更新
  ///
  /// zh_HK: 需要允許安裝未知應用才能安裝更新
  ///
  /// keyDesc: 未授予安装未知应用权限提示
  ///
  /// keyType: message
  @override
  String get installPermissionRequiredL10n =>
      installPermissionRequiredL10nEntry.value;

  String get installPermissionRequiredL10nKey =>
      installPermissionRequiredL10nEntry.key;

  L10nMixin get installPermissionRequiredL10nEntry =>
      L10n.update_checker_install_permission_required;

  /// key: update_checker_install_fail
  ///
  /// en: Install failed
  ///
  /// zh_CN: 安装失败
  ///
  /// zh_HK: 安裝失敗
  ///
  /// keyDesc: APK 安装失败提示
  ///
  /// keyType: error
  @override
  String get installFailL10n => installFailL10nEntry.value;

  String get installFailL10nKey => installFailL10nEntry.key;

  L10nMixin get installFailL10nEntry => L10n.update_checker_install_fail;

  /// key: update_checker_download_fail
  ///
  /// en: Download failed
  ///
  /// zh_CN: 下载失败
  ///
  /// zh_HK: 下載失敗
  ///
  /// keyDesc: 下载失败提示前缀
  ///
  /// keyType: error
  @override
  String get downloadFailL10n => downloadFailL10nEntry.value;

  String get downloadFailL10nKey => downloadFailL10nEntry.key;

  L10nMixin get downloadFailL10nEntry => L10n.update_checker_download_fail;

  /// key: update_checker_user_cancel_download
  ///
  /// en: User cancelled download
  ///
  /// zh_CN: 用户取消下载
  ///
  /// zh_HK: 用戶取消下載
  ///
  /// keyDesc: 用户取消下载（日志/内部）
  ///
  /// keyType: message
  @override
  String get userCancelDownloadL10n => userCancelDownloadL10nEntry.value;

  String get userCancelDownloadL10nKey => userCancelDownloadL10nEntry.key;

  L10nMixin get userCancelDownloadL10nEntry =>
      L10n.update_checker_user_cancel_download;
}