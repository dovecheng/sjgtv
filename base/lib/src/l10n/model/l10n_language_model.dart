import 'dart:ui';

import 'package:base/converter.dart';
import 'package:base/log.dart';
import 'package:collection/collection.dart';
import 'package:intl/intl.dart';
import 'package:intl/locale.dart' as intl;
import 'package:isar_community/isar.dart';

part 'l10n_language_model.g.dart';

/// 国际化语言
///
/// 自定义字段名解析: [L10nLanguageModel.fromJsonBuilder]
@Name('l10n_language')
@Collection(accessor: 'l10nLanguage')
class L10nLanguageModel {
  Id? id;

  String _languageTag;

  /// 语言标签
  String get languageTag => _languageTag;

  set languageTag(String value) {
    _languageTag = Intl.canonicalizedLocale(value);
    locale = localeFromLanguageTag(languageTag);
  }

  /// 语言区域
  @ignore
  Locale locale;

  /// 语言名称
  String displayName;

  /// 是否为默认语言
  bool? isDefault;

  /// 是否选中为当前语言
  bool? isSelected;

  L10nLanguageModel({
    this.id,
    required String languageTag,
    required this.displayName,
    this.isDefault,
    this.isSelected,
  })  : _languageTag = Intl.canonicalizedLocale(languageTag),
        locale = localeFromLanguageTag(languageTag);

  @ignore
  @override
  int get hashCode => languageTag.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is L10nLanguageModel &&
          runtimeType == other.runtimeType &&
          languageTag == other.languageTag;

  Map<String, dynamic> toJson() => {
        'id': id,
        'languageTag': languageTag,
        'displayName': displayName,
        'isDefault': isDefault,
        'isSelected': isSelected,
      };

  /// 自定义Json反序列化
  ///
  /// ```dart
  /// JSONConverter.registerFromJson(
  ///   L10nLanguageModel.fromJsonBuilder(languageTagFieldName: 'languageCode',
  ///     displayNameFieldName: 'languageName'));
  /// ```
  static L10nLanguageModel Function(Map<String, dynamic> json) fromJsonBuilder({
    String idFieldName = 'id',
    String languageTagFieldName = 'languageTag',
    String displayNameFieldName = 'displayName',
    String isDefaultFieldName = 'isDefault',
    String isSelectedFieldName = 'isSelected',
  }) =>
      (Map<String, dynamic> json) {
        String languageTag =
            StringConverter.toStringify(json[languageTagFieldName]);
        return L10nLanguageModel(
          id: IntConverter.toIntOrNull(json[idFieldName]),
          languageTag: languageTag,
          displayName: StringConverter.toStringify(
            json[displayNameFieldName] ?? languageTag,
          ),
          isDefault: BoolConverter.toBoolOrNull(json[isDefaultFieldName]),
          isSelected: BoolConverter.toBoolOrNull(json[isSelectedFieldName]),
        );
      };

  /// 语言决议, 从语言列表中返回选中语言
  static L10nLanguageModel languageResolution(
    Iterable<L10nLanguageModel> languages,
  ) {
    assert(languages.isNotEmpty, '语言列表不能为空');

    // 获取当前选中语言或默认语言
    L10nLanguageModel? language =
        languages.firstWhereOrNull(
          (L10nLanguageModel e) => e.isSelected == true,
        ) ??
        languages.firstWhereOrNull(
          (L10nLanguageModel e) => e.isDefault == true,
        );

    // 或根据设备语言匹配支持的语言
    if (language == null) {
      // 系统语言环境
      Locale systemLocale = PlatformDispatcher.instance.locale;

      Log log = Log('L10nLanguageModel');
      log.d(() => 'systemLocale=$systemLocale');

      // 完全匹配
      language = languages.firstWhereOrNull(
        (L10nLanguageModel e) => e.locale == systemLocale,
      );

      if (language == null) {
        // 中文地区特殊处理
        (String, String?) systemLanguageTag = (
          systemLocale.languageCode,
          systemLocale.languageCode == 'zh'
              ? switch (systemLocale.countryCode) {
                  'SG' => 'CN',
                  'MO' || 'TW' => 'HK',
                  _ => systemLocale.countryCode,
                }
              : systemLocale.countryCode,
        );

        // 匹配编码和地区
        language = languages.firstWhereOrNull(
          (L10nLanguageModel e) =>
              e.locale.languageCode == systemLanguageTag.$1 &&
              e.locale.countryCode == systemLanguageTag.$2,
        );

        // 仅匹配编码
        language ??= languages.firstWhereOrNull(
          (L10nLanguageModel e) =>
              e.locale.languageCode == systemLanguageTag.$1,
        );
      }
    }

    // 以上未匹配时, 默认第一个语言
    language ??= languages.first;
    language.isSelected = true;

    return language;
  }

  /// 解析语言标签
  static Locale localeFromLanguageTag(
    String languageTag, [
    bool withoutScriptCode = true,
  ]) {
    intl.Locale locale = intl.Locale.parse(languageTag);
    return withoutScriptCode
        ? Locale(locale.languageCode, locale.countryCode)
        : Locale.fromSubtags(
            languageCode: locale.languageCode,
            scriptCode: locale.scriptCode,
            countryCode: locale.countryCode,
          );
  }
}
