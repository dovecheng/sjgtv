// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'package_info_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 应用信息 [packageInfoProvider]

@ProviderFor(PackageInfoProvider)
const packageInfoProvider = PackageInfoProviderProvider._();

/// 应用信息 [packageInfoProvider]
final class PackageInfoProviderProvider
    extends $AsyncNotifierProvider<PackageInfoProvider, PackageInfo> {
  /// 应用信息 [packageInfoProvider]
  const PackageInfoProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'packageInfoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$packageInfoProviderHash();

  @$internal
  @override
  PackageInfoProvider create() => PackageInfoProvider();
}

String _$packageInfoProviderHash() =>
    r'84dff5936339aec39bd0aca8ae5342de415add66';

/// 应用信息 [packageInfoProvider]

abstract class _$PackageInfoProvider extends $AsyncNotifier<PackageInfo> {
  FutureOr<PackageInfo> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<PackageInfo>, PackageInfo>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<PackageInfo>, PackageInfo>,
              AsyncValue<PackageInfo>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
