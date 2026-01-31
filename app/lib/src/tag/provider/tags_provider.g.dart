// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tags_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 标签列表提供者 [tagsStorageProvider]
///
/// build 为从 Isar 获取列表；增删改通过 notifier 方法，写库后 invalidate 自身刷新。

@ProviderFor(TagsStorageProvider)
const tagsStorageProvider = TagsStorageProviderProvider._();

/// 标签列表提供者 [tagsStorageProvider]
///
/// build 为从 Isar 获取列表；增删改通过 notifier 方法，写库后 invalidate 自身刷新。
final class TagsStorageProviderProvider
    extends $AsyncNotifierProvider<TagsStorageProvider, List<TagModel>> {
  /// 标签列表提供者 [tagsStorageProvider]
  ///
  /// build 为从 Isar 获取列表；增删改通过 notifier 方法，写库后 invalidate 自身刷新。
  const TagsStorageProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'tagsStorageProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$tagsStorageProviderHash();

  @$internal
  @override
  TagsStorageProvider create() => TagsStorageProvider();
}

String _$tagsStorageProviderHash() =>
    r'5146adfc68d126cb76c489885128fa9b1e437816';

/// 标签列表提供者 [tagsStorageProvider]
///
/// build 为从 Isar 获取列表；增删改通过 notifier 方法，写库后 invalidate 自身刷新。

abstract class _$TagsStorageProvider extends $AsyncNotifier<List<TagModel>> {
  FutureOr<List<TagModel>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<TagModel>>, List<TagModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<TagModel>>, List<TagModel>>,
              AsyncValue<List<TagModel>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
