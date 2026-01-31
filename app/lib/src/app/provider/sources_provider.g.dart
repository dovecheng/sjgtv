// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sources_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 源列表提供者
///
/// 页面通过 [ref.watch] 监听，增删改或切换启用后 [ref.invalidate] 本提供者即可自动刷新。

@ProviderFor(SourcesProvider)
const sourcesProvider = SourcesProviderProvider._();

/// 源列表提供者
///
/// 页面通过 [ref.watch] 监听，增删改或切换启用后 [ref.invalidate] 本提供者即可自动刷新。
final class SourcesProviderProvider
    extends $AsyncNotifierProvider<SourcesProvider, List<Source>> {
  /// 源列表提供者
  ///
  /// 页面通过 [ref.watch] 监听，增删改或切换启用后 [ref.invalidate] 本提供者即可自动刷新。
  const SourcesProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sourcesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sourcesProviderHash();

  @$internal
  @override
  SourcesProvider create() => SourcesProvider();
}

String _$sourcesProviderHash() => r'11160cc082c1ec1d962f2360a674ba865fa91a3d';

/// 源列表提供者
///
/// 页面通过 [ref.watch] 监听，增删改或切换启用后 [ref.invalidate] 本提供者即可自动刷新。

abstract class _$SourcesProvider extends $AsyncNotifier<List<Source>> {
  FutureOr<List<Source>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<Source>>, List<Source>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<Source>>, List<Source>>,
              AsyncValue<List<Source>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
