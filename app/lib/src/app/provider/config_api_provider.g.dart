// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'config_api_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 远程配置 API 请求结果提供者
///
/// build 为调用 [ConfigApi].getConfig() 的返回结果（Map）。

@ProviderFor(ConfigApiProvider)
const configApiProvider = ConfigApiProviderProvider._();

/// 远程配置 API 请求结果提供者
///
/// build 为调用 [ConfigApi].getConfig() 的返回结果（Map）。
final class ConfigApiProviderProvider
    extends $AsyncNotifierProvider<ConfigApiProvider, Map<String, dynamic>?> {
  /// 远程配置 API 请求结果提供者
  ///
  /// build 为调用 [ConfigApi].getConfig() 的返回结果（Map）。
  const ConfigApiProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'configApiProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$configApiProviderHash();

  @$internal
  @override
  ConfigApiProvider create() => ConfigApiProvider();
}

String _$configApiProviderHash() => r'8bf17d8fc72beda39c36d742efc4c76ffebd16a7';

/// 远程配置 API 请求结果提供者
///
/// build 为调用 [ConfigApi].getConfig() 的返回结果（Map）。

abstract class _$ConfigApiProvider
    extends $AsyncNotifier<Map<String, dynamic>?> {
  FutureOr<Map<String, dynamic>?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref
            as $Ref<AsyncValue<Map<String, dynamic>?>, Map<String, dynamic>?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<
                AsyncValue<Map<String, dynamic>?>,
                Map<String, dynamic>?
              >,
              AsyncValue<Map<String, dynamic>?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
