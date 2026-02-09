// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_datasource_impl.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 本地数据源实现
///
/// 使用 Isar 数据库实现本地数据访问

@ProviderFor(LocalDataSourceImpl)
const localDataSourceImpl = LocalDataSourceImplProvider._();

/// 本地数据源实现
///
/// 使用 Isar 数据库实现本地数据访问
final class LocalDataSourceImplProvider
    extends $NotifierProvider<LocalDataSourceImpl, LocalDataSourceImpl> {
  /// 本地数据源实现
  ///
  /// 使用 Isar 数据库实现本地数据访问
  const LocalDataSourceImplProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'localDataSourceImpl',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$localDataSourceImplHash();

  @$internal
  @override
  LocalDataSourceImpl create() => LocalDataSourceImpl();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(LocalDataSourceImpl value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<LocalDataSourceImpl>(value),
    );
  }
}

String _$localDataSourceImplHash() =>
    r'fb15af4ddd221e05b86a463fb17ce9771ffd6456';

/// 本地数据源实现
///
/// 使用 Isar 数据库实现本地数据访问

abstract class _$LocalDataSourceImpl extends $Notifier<LocalDataSourceImpl> {
  LocalDataSourceImpl build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<LocalDataSourceImpl, LocalDataSourceImpl>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<LocalDataSourceImpl, LocalDataSourceImpl>,
              LocalDataSourceImpl,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
