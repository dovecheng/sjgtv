// GENERATED CODE BY 2026-01-30 07:39:47 - DO NOT MODIFY BY HAND

import 'package:base/gen/l10n.gen.dart';
import 'package:base/l10n.dart';

import 'permission_l10n.dart';

export 'permission_l10n.dart';

/// has 3 keys
///
/// keysPrefix: permission
///
/// usedContext:
///
/// keysDesc: 权限相关的错误提示内容本地化
mixin PermissionL10nMixin implements PermissionL10n {
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
  @override
  String get cameraDeniedL10n => cameraDeniedL10nEntry.value;

  String get cameraDeniedL10nKey => cameraDeniedL10nEntry.key;

  L10nMixin get cameraDeniedL10nEntry => L10n.permission_camera_denied;

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
  @override
  String get photosDeniedL10n => photosDeniedL10nEntry.value;

  String get photosDeniedL10nKey => photosDeniedL10nEntry.key;

  L10nMixin get photosDeniedL10nEntry => L10n.permission_photos_denied;

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
  @override
  String get storageDeniedL10n => storageDeniedL10nEntry.value;

  String get storageDeniedL10nKey => storageDeniedL10nEntry.key;

  L10nMixin get storageDeniedL10nEntry => L10n.permission_storage_denied;
}