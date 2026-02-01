import 'package:base/gen/l10n.gen.dart';
import 'package:base/l10n.dart';
import 'package:base/log.dart';
import 'package:collection/collection.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'l10n_translation_provider.g.dart';

L10nTranslationModel? _tr;
L10nTranslationModel? get $tr => _tr;

/// 国际化翻译 [l10nTranslationProvider]（仅本地预设）
@Riverpod(keepAlive: true, dependencies: [L10nLanguageProvider])
class L10nTranslationProvider extends _$L10nTranslationProvider {
  final Set<L10nTranslationModel> presetTranslations;

  L10nTranslationProvider([Set<L10nTranslationModel>? presetTranslations])
    : presetTranslations = presetTranslations ?? L10n.translations,
      assert(presetTranslations == null || presetTranslations.isNotEmpty);

  @override
  Future<L10nTranslationModel> build() async {
    var (L10nLanguageModel language, Set<L10nLanguageModel> languages) =
        await ref.watch(l10nLanguageProvider.future);

    log.d(() => '当前语言=${language.languageTag}');

    L10nTranslationModel? tr = presetTranslations.firstWhereOrNull(
      (e) => e.languageTag == language.languageTag,
    );

    while (tr?.isNotEmpty != true && languages.length > 1) {
      languages = languages.whereNot((e) => e == language).toSet();
      language = L10nLanguageModel.languageResolution(languages);
      tr = presetTranslations.firstWhereOrNull(
        (e) => e.languageTag == language.languageTag,
      );
    }

    tr ??= presetTranslations.first;
    final L10nTranslationModel result = tr;

    if (presetTranslations != L10n.translations) {
      L10nTranslationModel? baseTr = L10n.translations.firstWhereOrNull(
        (L10nTranslationModel e) => e.languageTag == result.languageTag,
      );
      baseTr ??= L10n.translations.first;
      result.translations = {...?baseTr.translations, ...?result.translations};
    }

    log.d(() => '本地国际化翻译: ${result.translations?.length}');
    return _tr = result;
  }
}
