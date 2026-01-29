// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_provider_select.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TestProvider)
const testProvider = TestProviderProvider._();

final class TestProviderProvider
    extends $NotifierProvider<TestProvider, Map<String, dynamic>> {
  const TestProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'testProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$testProviderHash();

  @$internal
  @override
  TestProvider create() => TestProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Map<String, dynamic> value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Map<String, dynamic>>(value),
    );
  }
}

String _$testProviderHash() => r'c396a460f73fd01c139bdeb131bad0c045e660fa';

abstract class _$TestProvider extends $Notifier<Map<String, dynamic>> {
  Map<String, dynamic> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<Map<String, dynamic>, Map<String, dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Map<String, dynamic>, Map<String, dynamic>>,
              Map<String, dynamic>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
