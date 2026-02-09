// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'favorites_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 收藏列表提供者

@ProviderFor(FavoritesProvider)
const favoritesProvider = FavoritesProviderProvider._();

/// 收藏列表提供者
final class FavoritesProviderProvider
    extends $AsyncNotifierProvider<FavoritesProvider, List<dynamic>> {
  /// 收藏列表提供者
  const FavoritesProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'favoritesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$favoritesProviderHash();

  @$internal
  @override
  FavoritesProvider create() => FavoritesProvider();
}

String _$favoritesProviderHash() => r'f35b3ea5b887ea1ca0f5992dd4721a4b6775dcb1';

/// 收藏列表提供者

abstract class _$FavoritesProvider extends $AsyncNotifier<List<dynamic>> {
  FutureOr<List<dynamic>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<List<dynamic>>, List<dynamic>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<dynamic>>, List<dynamic>>,
              AsyncValue<List<dynamic>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
