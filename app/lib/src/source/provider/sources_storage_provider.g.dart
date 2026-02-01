// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sources_storage_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 源列表提供者 [sourcesStorageProvider]
///
/// build 为从 Isar 获取列表；增删改通过 notifier 方法，写库后 invalidate 自身刷新。

@ProviderFor(SourcesStorageProvider)
const sourcesStorageProvider = SourcesStorageProviderProvider._();

/// 源列表提供者 [sourcesStorageProvider]
///
/// build 为从 Isar 获取列表；增删改通过 notifier 方法，写库后 invalidate 自身刷新。
final class SourcesStorageProviderProvider
    extends $AsyncNotifierProvider<SourcesStorageProvider, List<SourceModel>> {
  /// 源列表提供者 [sourcesStorageProvider]
  ///
  /// build 为从 Isar 获取列表；增删改通过 notifier 方法，写库后 invalidate 自身刷新。
  const SourcesStorageProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sourcesStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sourcesStorageProviderHash();

  @$internal
  @override
  SourcesStorageProvider create() => SourcesStorageProvider();
}

String _$sourcesStorageProviderHash() =>
    r'208e99f9e65c349dd30f905d4006992d1d2d72e5';

/// 源列表提供者 [sourcesStorageProvider]
///
/// build 为从 Isar 获取列表；增删改通过 notifier 方法，写库后 invalidate 自身刷新。

abstract class _$SourcesStorageProvider
    extends $AsyncNotifier<List<SourceModel>> {
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
