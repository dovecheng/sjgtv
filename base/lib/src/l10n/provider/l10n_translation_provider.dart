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
    : presetTranslations = presetTranslations ?? {},
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

    if (tr == null && presetTranslations.isNotEmpty) {
      tr = presetTranslations.first;
    }
    tr ??= L10nTranslationModel(
      languageTag: 'en',
      translations: <String, String>{},
    );

    log.d(() => '本地国际化翻译: ${tr?.translations?.length}');

    return tr;
  }
}
