// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'proxy_count_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 代理数量提供者 [proxyCountStorageProvider]

@ProviderFor(ProxyCountStorageProvider)
const proxyCountStorageProvider = ProxyCountStorageProviderProvider._();

/// 代理数量提供者 [proxyCountStorageProvider]
final class ProxyCountStorageProviderProvider
    extends $AsyncNotifierProvider<ProxyCountStorageProvider, int> {
  /// 代理数量提供者 [proxyCountStorageProvider]
  const ProxyCountStorageProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'proxyCountStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$proxyCountStorageProviderHash();

  @$internal
  @override
  ProxyCountStorageProvider create() => ProxyCountStorageProvider();
}

String _$proxyCountStorageProviderHash() =>
    r'6dd363b47753fa34d67c16ae700fd6af66d7b6d5';

/// 代理数量提供者 [proxyCountStorageProvider]

abstract class _$ProxyCountStorageProvider extends $AsyncNotifier<int> {
  FutureOr<int> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<int>, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<int>, int>,
              AsyncValue<int>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
