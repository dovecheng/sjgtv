// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'watch_histories_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 观看历史提供者
///
/// 管理观看历史数据

@ProviderFor(WatchHistoriesProvider)
const watchHistoriesProvider = WatchHistoriesProviderProvider._();

/// 观看历史提供者
///
/// 管理观看历史数据
final class WatchHistoriesProviderProvider
    extends $AsyncNotifierProvider<WatchHistoriesProvider, List<WatchHistory>> {
  /// 观看历史提供者
  ///
  /// 管理观看历史数据
  const WatchHistoriesProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'watchHistoriesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$watchHistoriesProviderHash();

  @$internal
  @override
  WatchHistoriesProvider create() => WatchHistoriesProvider();
}

String _$watchHistoriesProviderHash() =>
    r'68cfee575870cdc211e2ed7313f0be5a375c677a';

/// 观看历史提供者
///
/// 管理观看历史数据

abstract class _$WatchHistoriesProvider
    extends $AsyncNotifier<List<WatchHistory>> {
  FutureOr<List<WatchHistory>> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref =
        this.ref as $Ref<AsyncValue<List<WatchHistory>>, List<WatchHistory>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<WatchHistory>>, List<WatchHistory>>,
              AsyncValue<List<WatchHistory>>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
