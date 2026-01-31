// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tag_count_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 标签数量提供者 [tagCountStorageProvider]

@ProviderFor(TagCountStorageProvider)
const tagCountStorageProvider = TagCountStorageProviderProvider._();

/// 标签数量提供者 [tagCountStorageProvider]
final class TagCountStorageProviderProvider
    extends $AsyncNotifierProvider<TagCountStorageProvider, int> {
  /// 标签数量提供者 [tagCountStorageProvider]
  const TagCountStorageProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tagCountStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tagCountStorageProviderHash();

  @$internal
  @override
  TagCountStorageProvider create() => TagCountStorageProvider();
}

String _$tagCountStorageProviderHash() =>
    r'cc5f25ebe70321171d3800759122b3d30b90cbf7';

/// 标签数量提供者 [tagCountStorageProvider]

abstract class _$TagCountStorageProvider extends $AsyncNotifier<int> {
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
