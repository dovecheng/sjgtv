// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_service_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// ApiService 提供者
///
/// 使用 base 的 [apiClientProvider]（Dio）创建 [ApiService]，供页面通过 ref 获取。

@ProviderFor(ApiServiceProvider)
const apiServiceProvider = ApiServiceProviderProvider._();

/// ApiService 提供者
///
/// 使用 base 的 [apiClientProvider]（Dio）创建 [ApiService]，供页面通过 ref 获取。
final class ApiServiceProviderProvider
    extends $NotifierProvider<ApiServiceProvider, ApiService> {
  /// ApiService 提供者
  ///
  /// 使用 base 的 [apiClientProvider]（Dio）创建 [ApiService]，供页面通过 ref 获取。
  const ApiServiceProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiServiceProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiServiceProviderHash();

  @$internal
  @override
  ApiServiceProvider create() => ApiServiceProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ApiService value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ApiService>(value),
    );
  }
}

String _$apiServiceProviderHash() =>
    r'e1ffb0c317a25629abc232b71188241d8ac377a4';

/// ApiService 提供者
///
/// 使用 base 的 [apiClientProvider]（Dio）创建 [ApiService]，供页面通过 ref 获取。

abstract class _$ApiServiceProvider extends $Notifier<ApiService> {
  ApiService build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<ApiService, ApiService>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ApiService, ApiService>,
              ApiService,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
