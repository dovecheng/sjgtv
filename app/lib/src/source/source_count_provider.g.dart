// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'source_count_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 源数量提供者 [sourceCountStorageProvider]（用于判断是否需初始写入）

@ProviderFor(SourceCountStorageProvider)
const sourceCountStorageProvider = SourceCountStorageProviderProvider._();

/// 源数量提供者 [sourceCountStorageProvider]（用于判断是否需初始写入）
final class SourceCountStorageProviderProvider
    extends $AsyncNotifierProvider<SourceCountStorageProvider, int> {
  /// 源数量提供者 [sourceCountStorageProvider]（用于判断是否需初始写入）
  const SourceCountStorageProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sourceCountStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sourceCountStorageProviderHash();

  @$internal
  @override
  SourceCountStorageProvider create() => SourceCountStorageProvider();
}

String _$sourceCountStorageProviderHash() =>
    r'63478272957bc9066589d69d82c71bc9a1aadae6';

/// 源数量提供者 [sourceCountStorageProvider]（用于判断是否需初始写入）

abstract class _$SourceCountStorageProvider extends $AsyncNotifier<int> {
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
