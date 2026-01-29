import 'package:base/isar.dart';
import 'package:base/l10n.dart';
import 'package:base/log.dart';
import 'package:isar_community/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'l10n_language_provider.g.dart';

/// 国际化语言 [l10nLanguageProvider]（仅本地预设，切换结果持久化）
@Riverpod(keepAlive: true)
class L10nLanguageProvider extends _$L10nLanguageProvider {
  final Set<L10nLanguageModel> _presetLanguages;

  L10nLanguageProvider({Set<L10nLanguageModel>? presetLanguages})
    : _presetLanguages =
          presetLanguages ??
          <L10nLanguageModel>{
            L10nLanguageModel(languageTag: 'en', displayName: 'EN'),
            L10nLanguageModel(languageTag: 'zh-CN', displayName: '简中'),
            L10nLanguageModel(languageTag: 'zh-HK', displayName: '繁中'),
          };

  @override
  Future<(L10nLanguageModel, Set<L10nLanguageModel>)> build() async {
    log.d(() => '查询语言列表');
    List<L10nLanguageModel> languages =
        await $isar.l10nLanguage.where().anyId().findAll();

    if (languages.isEmpty) {
      log.d(() => '使用预设语言列表');
      languages.addAll(_presetLanguages);
    }

    return (
      L10nLanguageModel.languageResolution(languages),
      languages.toSet(),
    );
  }

  /// 切换当前语言（持久化到本地库）
  Future<void> changeLanguage(L10nLanguageModel language) async {
    Set<L10nLanguageModel> languages = (await future).$2;

    if (!languages.contains(language)) {
      log.w(
        () =>
            'language ${language.toJson()} '
            'not in languages ${languages.map((L10nLanguageModel e) => e.toJson())}',
      );
    }

    for (L10nLanguageModel item in languages) {
      if (item.isSelected = item.languageTag == language.languageTag) {
        language = item;
      }
    }

    try {
      await $isar.writeTxn(() => $isar.l10nLanguage.putAll(languages.toList()));
    } catch (e, s) {
      log.e(() => '持久化语言切换失败', e, s);
    }

    state = AsyncData<(L10nLanguageModel, Set<L10nLanguageModel>)>((
      language,
      languages,
    ));
  }
}
