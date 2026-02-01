import 'package:base/l10n.dart';

@L10nKeys(
  keysPrefix: 'source',
  keysDesc: 'Flutter 源管理/添加源页专属，网页用 web_l10n',
)
abstract interface class SourceL10n {
  @L10nKey(
    en: 'Source Manage',
    zh_CN: '源管理',
    zh_HK: '源管理',
    keyDesc: '源管理页标题',
    keyType: L10nKeyType.label,
  )
  String get manageTitleL10n;

  @L10nKey(
    en: 'Source List',
    zh_CN: '源列表',
    zh_HK: '源列表',
    keyDesc: '源列表卡片标题',
    keyType: L10nKeyType.label,
  )
  String get listTitleL10n;

  @L10nKey(
    en: 'Add Data Source',
    zh_CN: '添加数据源',
    zh_HK: '添加數據源',
    keyDesc: '添加数据源页标题',
    keyType: L10nKeyType.label,
  )
  String get addTitleL10n;

  @L10nKey(
    en: 'Name',
    zh_CN: '名称',
    zh_HK: '名稱',
    keyDesc: '数据源名称',
    keyType: L10nKeyType.label,
  )
  String get nameL10n;

  @L10nKey(
    en: 'URL (http or https)',
    zh_CN: '地址（http 或 https）',
    zh_HK: '地址（http 或 https）',
    keyDesc: '数据源地址输入提示',
    keyType: L10nKeyType.label,
  )
  String get urlHintL10n;

  @L10nKey(
    en: 'Save',
    zh_CN: '保存',
    zh_HK: '保存',
    keyDesc: '保存按钮',
    keyType: L10nKeyType.label,
  )
  String get saveL10n;

  @L10nKey(
    en: 'Cancel',
    zh_CN: '取消',
    zh_HK: '取消',
    keyDesc: '取消按钮',
    keyType: L10nKeyType.label,
  )
  String get cancelL10n;

  @L10nKey(
    en: 'No data sources',
    zh_CN: '暂无数据源',
    zh_HK: '暫無數據源',
    keyDesc: '源列表为空时提示',
    keyType: L10nKeyType.message,
  )
  String get noSourcesL10n;

  @L10nKey(
    en: 'Retry',
    zh_CN: '重试',
    zh_HK: '重試',
    keyDesc: '重试按钮',
    keyType: L10nKeyType.label,
  )
  String get retryL10n;
}
