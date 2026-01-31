// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proxies_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 代理列表提供者 [proxiesStorageProvider]
///
/// build 为从 Isar 获取列表；增删改通过 notifier 方法，写库后 invalidate 自身刷新。

@ProviderFor(ProxiesStorageProvider)
const proxiesStorageProvider = ProxiesStorageProviderProvider._();

/// 代理列表提供者 [proxiesStorageProvider]
///
/// build 为从 Isar 获取列表；增删改通过 notifier 方法，写库后 invalidate 自身刷新。
final class ProxiesStorageProviderProvider
    extends $AsyncNotifierProvider<ProxiesStorageProvider, List<ProxyModel>> {
  /// 代理列表提供者 [proxiesStorageProvider]
  ///
  /// build 为从 Isar 获取列表；增删改通过 notifier 方法，写库后 invalidate 自身刷新。
  const ProxiesStorageProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'proxiesStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$proxiesStorageProviderHash();

  @$internal
  @override
  ProxiesStorageProvider create() => ProxiesStorageProvider();
}

String _$proxiesStorageProviderHash() =>
    r'c2143cee857f729a23392961f023eb5cf6ecd0c6';

/// 代理列表提供者 [proxiesStorageProvider]
///
/// build 为从 Isar 获取列表；增删改通过 notifier 方法，写库后 invalidate 自身刷新。

abstract class _$ProxiesStorageProvider
    extends $AsyncNotifier<List<ProxyModel>> {
  FutureOr<List<ProxyModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<ProxyModel>>, List<ProxyModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<ProxyModel>>, List<ProxyModel>>,
              AsyncValue<List<ProxyModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
