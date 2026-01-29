import 'dart:collection';
import 'dart:convert';

import 'package:intl/intl.dart';
import 'package:isar_community/isar.dart';
import 'package:meta/meta.dart';

part 'l10n_translation_model.g.dart';

/// 国际化翻译
@Name('l10n_translation')
@Collection(accessor: 'l10nTransaction', inheritance: false)
class L10nTranslationModel with MapMixin<String, String> {
  Id? id;

  /// 语言标签
  String languageTag;

  /// 翻译
  @ignore
  Map<String, String>? translations;

  L10nTranslationModel({
    this.id,
    required String languageTag,
    this.translations,
  }) : languageTag = Intl.canonicalizedLocale(languageTag);

  @ignore
  @override
  int get hashCode => languageTag.hashCode;

  @ignore
  @override
  Iterable<String> get keys => translations?.keys ?? const [];

  @visibleForTesting
  String get stringify => jsonEncode(translations);

  @visibleForTesting
  set stringify(String value) {
    Map<String, dynamic>? map = jsonDecode(value);
    translations = map?.cast();
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is L10nTranslationModel &&
          runtimeType == other.runtimeType &&
          languageTag == other.languageTag;

  @override
  String? operator [](Object? key) => translations?[key];

  @override
  void operator []=(String key, String value) =>
      (translations ?? {})[key] = value;

  @override
  void clear() => translations?.clear();

  @override
  String? remove(Object? key) => translations?.remove(key);

  Map<String, dynamic> toJson() => {
    'id': id,
    'languageTag': languageTag,
    'translations': translations,
  };
}
