// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debug_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 调试配置 [debugProvider]

@ProviderFor(DebugProvider)
const debugProvider = DebugProviderProvider._();

/// 调试配置 [debugProvider]
final class DebugProviderProvider
    extends $AsyncNotifierProvider<DebugProvider, DebugModel> {
  /// 调试配置 [debugProvider]
  const DebugProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'debugProvider',
        isAutoDispose: false,
        dependencies: const <ProviderOrFamily>[appConfigProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          DebugProviderProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = appConfigProvider;

  @override
  String debugGetCreateSourceHash() => _$debugProviderHash();

  @$internal
  @override
  DebugProvider create() => DebugProvider();
}

String _$debugProviderHash() => r'7f85e6d4f5a7f1ecca7676c6cff622e6893efd89';

/// 调试配置 [debugProvider]

abstract class _$DebugProvider extends $AsyncNotifier<DebugModel> {
  FutureOr<DebugModel> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<DebugModel>, DebugModel>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<DebugModel>, DebugModel>,
              AsyncValue<DebugModel>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
