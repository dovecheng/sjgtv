// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'isar_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 数据库实例 [isarProvider]
///
/// 暂时不支持Web

@ProviderFor(IsarProvider)
const isarProvider = IsarProviderProvider._();

/// 数据库实例 [isarProvider]
///
/// 暂时不支持Web
final class IsarProviderProvider
    extends $AsyncNotifierProvider<IsarProvider, Isar> {
  /// 数据库实例 [isarProvider]
  ///
  /// 暂时不支持Web
  const IsarProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'isarProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$isarProviderHash();

  @$internal
  @override
  IsarProvider create() => IsarProvider();
}

String _$isarProviderHash() => r'b68360e2c0f9444cf336eb66745c567df36c30ee';

/// 数据库实例 [isarProvider]
///
/// 暂时不支持Web

abstract class _$IsarProvider extends $AsyncNotifier<Isar> {
  FutureOr<Isar> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Isar>, Isar>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Isar>, Isar>,
              AsyncValue<Isar>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
