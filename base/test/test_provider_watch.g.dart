// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_provider_watch.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(Test1Provider)
const test1Provider = Test1ProviderProvider._();

final class Test1ProviderProvider
    extends $NotifierProvider<Test1Provider, int> {
  const Test1ProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'test1Provider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$test1ProviderHash();

  @$internal
  @override
  Test1Provider create() => Test1Provider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$test1ProviderHash() => r'1b99342de0dd4f3500a91d7cc15a1463371f0daf';

abstract class _$Test1Provider extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}

@ProviderFor(Test2Provider)
const test2Provider = Test2ProviderProvider._();

final class Test2ProviderProvider
    extends $NotifierProvider<Test2Provider, int> {
  const Test2ProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'test2Provider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$test2ProviderHash();

  @$internal
  @override
  Test2Provider create() => Test2Provider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$test2ProviderHash() => r'41a52a37e65958559851d979bc935995cb373f8a';

abstract class _$Test2Provider extends $Notifier<int> {
  int build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<int, int>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<int, int>,
              int,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
