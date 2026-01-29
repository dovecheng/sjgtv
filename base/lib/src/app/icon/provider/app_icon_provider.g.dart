// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_icon_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 应用图标切换器 [appIconProvider]

@ProviderFor(AppIconProvider)
const appIconProvider = AppIconProviderProvider._();

/// 应用图标切换器 [appIconProvider]
final class AppIconProviderProvider
    extends $AsyncNotifierProvider<AppIconProvider, AppIconModel?> {
  /// 应用图标切换器 [appIconProvider]
  const AppIconProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appIconProvider',
        isAutoDispose: true,
        dependencies: const <ProviderOrFamily>[appConfigProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          AppIconProviderProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = appConfigProvider;

  @override
  String debugGetCreateSourceHash() => _$appIconProviderHash();

  @$internal
  @override
  AppIconProvider create() => AppIconProvider();
}

String _$appIconProviderHash() => r'bfbe98b4d1ab72d8657c5d20cb6804620ebebd15';

/// 应用图标切换器 [appIconProvider]

abstract class _$AppIconProvider extends $AsyncNotifier<AppIconModel?> {
  FutureOr<AppIconModel?> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<AppIconModel?>, AppIconModel?>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<AppIconModel?>, AppIconModel?>,
              AsyncValue<AppIconModel?>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
