// GENERATED CODE BY 2026-02-02 02:57:19 - DO NOT MODIFY BY HAND

import 'package:base/l10n.dart';
import 'package:sjgtv/gen/l10n.gen.dart';

import 'app_l10n.dart';

export 'app_l10n.dart';

/// has 1 keys
///
/// keysPrefix: app
///
/// usedContext:
///
/// keysDesc: 应用级文案（如 MaterialApp title）
mixin AppL10nMixin implements AppL10n {
  /// key: app_title
  ///
  /// en: AppleCMS Movie Player
  ///
  /// zh_CN: 苹果CMS电影播放器
  ///
  /// zh_HK: 蘋果CMS電影播放器
  ///
  /// keyDesc: 应用标题（MaterialApp title、任务栏等）
  ///
  /// keyType: label
  @override
  String get titleL10n => titleL10nEntry.value;

  String get titleL10nKey => titleL10nEntry.key;

  L10nMixin get titleL10nEntry => L10n.app_title;
}