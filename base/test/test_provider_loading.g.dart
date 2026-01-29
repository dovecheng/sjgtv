// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'test_provider_loading.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(TestProvider)
const testProvider = TestProviderProvider._();

final class TestProviderProvider
    extends $AsyncNotifierProvider<TestProvider, int> {
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
}

String _$testProviderHash() => r'1917dacf1f40a89203bc477290fe15732f724ef7';

abstract class _$TestProvider extends $AsyncNotifier<int> {
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
