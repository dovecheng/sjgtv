// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sources_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 源列表提供者 [sourcesProvider]
///
/// build 为从 Isar 获取列表；增删改通过 notifier 方法，写库后 invalidate 自身刷新。

@ProviderFor(SourcesProvider)
const sourcesProvider = SourcesProviderProvider._();

/// 源列表提供者 [sourcesProvider]
///
/// build 为从 Isar 获取列表；增删改通过 notifier 方法，写库后 invalidate 自身刷新。
final class SourcesProviderProvider
    extends $AsyncNotifierProvider<SourcesProvider, List<SourceModel>> {
  /// 源列表提供者 [sourcesProvider]
  ///
  /// build 为从 Isar 获取列表；增删改通过 notifier 方法，写库后 invalidate 自身刷新。
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

String _$sourcesProviderHash() => r'c19c55fb236a23463d29c2a6f3f8d7d0e296a001';

/// 源列表提供者 [sourcesProvider]
///
/// build 为从 Isar 获取列表；增删改通过 notifier 方法，写库后 invalidate 自身刷新。

abstract class _$SourcesProvider extends $AsyncNotifier<List<SourceModel>> {
  FutureOr<List<SourceModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<SourceModel>>, List<SourceModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<SourceModel>>, List<SourceModel>>,
              AsyncValue<List<SourceModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
