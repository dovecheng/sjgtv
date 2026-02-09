// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'api_client_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// HTTP客户端 [apiClientProvider]
///
/// 覆盖配置:
/// ```dart
/// apiClientProvider.overrideWith(() =>
///       ApiClient(
///           intercepts: [...],
///           baseOptions: BaseOptions(...)
///       ));
/// ```

@ProviderFor(ApiClientProvider)
const apiClientProvider = ApiClientProviderProvider._();

/// HTTP客户端 [apiClientProvider]
///
/// 覆盖配置:
/// ```dart
/// apiClientProvider.overrideWith(() =>
///       ApiClient(
///           intercepts: [...],
///           baseOptions: BaseOptions(...)
///       ));
/// ```
final class ApiClientProviderProvider
    extends $NotifierProvider<ApiClientProvider, Dio> {
  /// HTTP客户端 [apiClientProvider]
  ///
  /// 覆盖配置:
  /// ```dart
  /// apiClientProvider.overrideWith(() =>
  ///       ApiClient(
  ///           intercepts: [...],
  ///           baseOptions: BaseOptions(...)
  ///       ));
  /// ```
  const ApiClientProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'apiClientProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$apiClientProviderHash();

  @$internal
  @override
  ApiClientProvider create() => ApiClientProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Dio value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Dio>(value),
    );
  }
}

String _$apiClientProviderHash() => r'8f32aa67ead225a77f1c623fd61e6e4ed99019f5';

/// HTTP客户端 [apiClientProvider]
///
/// 覆盖配置:
/// ```dart
/// apiClientProvider.overrideWith(() =>
///       ApiClient(
///           intercepts: [...],
///           baseOptions: BaseOptions(...)
///       ));
/// ```

abstract class _$ApiClientProvider extends $Notifier<Dio> {
  Dio build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Dio, Dio>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Dio, Dio>,
              Dio,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
