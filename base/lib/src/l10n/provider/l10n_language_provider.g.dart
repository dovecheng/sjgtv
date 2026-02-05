// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'l10n_language_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 国际化语言 [l10nLanguageProvider]（仅本地预设，切换结果持久化）

@ProviderFor(L10nLanguageProvider)
const l10nLanguageProvider = L10nLanguageProviderProvider._();

/// 国际化语言 [l10nLanguageProvider]（仅本地预设，切换结果持久化）
final class L10nLanguageProviderProvider
    extends
        $AsyncNotifierProvider<
          L10nLanguageProvider,
          (L10nLanguageModel, Set<L10nLanguageModel>)
        > {
  /// 国际化语言 [l10nLanguageProvider]（仅本地预设，切换结果持久化）
  const L10nLanguageProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'l10nLanguageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$l10nLanguageProviderHash();

  @$internal
  @override
  L10nLanguageProvider create() => L10nLanguageProvider();
}

String _$l10nLanguageProviderHash() =>
    r'5f7cb30bee7289efc3cb528f6a31893644253642';

/// 国际化语言 [l10nLanguageProvider]（仅本地预设，切换结果持久化）

abstract class _$L10nLanguageProvider
    extends $AsyncNotifier<(L10nLanguageModel, Set<L10nLanguageModel>)> {
  FutureOr<(L10nLanguageModel, Set<L10nLanguageModel>)> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<
              AsyncValue<(L10nLanguageModel, Set<L10nLanguageModel>)>,
              (L10nLanguageModel, Set<L10nLanguageModel>)
            >;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<(L10nLanguageModel, Set<L10nLanguageModel>)>,
                (L10nLanguageModel, Set<L10nLanguageModel>)
              >,
              AsyncValue<(L10nLanguageModel, Set<L10nLanguageModel>)>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
