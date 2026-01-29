// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'json_adapter_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 注册Json转换器 [jsonAdapterProvider]

@ProviderFor(JsonAdapterProvider)
const jsonAdapterProvider = JsonAdapterProviderProvider._();

/// 注册Json转换器 [jsonAdapterProvider]
final class JsonAdapterProviderProvider
    extends $NotifierProvider<JsonAdapterProvider, void> {
  /// 注册Json转换器 [jsonAdapterProvider]
  const JsonAdapterProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'jsonAdapterProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$jsonAdapterProviderHash();

  @$internal
  @override
  JsonAdapterProvider create() => JsonAdapterProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$jsonAdapterProviderHash() =>
    r'3dc5803ebd879210228fc4fe47b83113dffacbf9';

/// 注册Json转换器 [jsonAdapterProvider]

abstract class _$JsonAdapterProvider extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
