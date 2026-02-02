import 'package:base/l10n.dart';

@L10nKeys(
  keysPrefix: 'app',
  keysDesc: '应用级文案（如 MaterialApp title）',
)
abstract interface class AppL10n {
  @L10nKey(
    en: 'AppleCMS Movie Player',
    zh_CN: '苹果CMS电影播放器',
    zh_HK: '蘋果CMS電影播放器',
    keyDesc: '应用标题（MaterialApp title、任务栏等）',
    keyType: L10nKeyType.label,
  )
  String get titleL10n;
}
