// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'l10n_translation_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 国际化翻译 [l10nTranslationProvider]（仅本地预设）

@ProviderFor(L10nTranslationProvider)
const l10nTranslationProvider = L10nTranslationProviderProvider._();

/// 国际化翻译 [l10nTranslationProvider]（仅本地预设）
final class L10nTranslationProviderProvider
    extends
        $AsyncNotifierProvider<L10nTranslationProvider, L10nTranslationModel> {
  /// 国际化翻译 [l10nTranslationProvider]（仅本地预设）
  const L10nTranslationProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'l10nTranslationProvider',
        isAutoDispose: false,
        dependencies: const <ProviderOrFamily>[l10nLanguageProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          L10nTranslationProviderProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = l10nLanguageProvider;

  @override
  String debugGetCreateSourceHash() => _$l10nTranslationProviderHash();

  @$internal
  @override
  L10nTranslationProvider create() => L10nTranslationProvider();
}

String _$l10nTranslationProviderHash() =>
    r'a0d901430a83f8c9cdda9887eaa8cff05157a4dc';

/// 国际化翻译 [l10nTranslationProvider]（仅本地预设）

abstract class _$L10nTranslationProvider
    extends $AsyncNotifier<L10nTranslationModel> {
  FutureOr<L10nTranslationModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<L10nTranslationModel>, L10nTranslationModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<L10nTranslationModel>,
                L10nTranslationModel
              >,
              AsyncValue<L10nTranslationModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
