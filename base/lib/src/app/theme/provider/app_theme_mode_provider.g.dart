// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_theme_mode_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 切换主题服务 [appThemeModeProvider]

@ProviderFor(AppThemeModeProvider)
const appThemeModeProvider = AppThemeModeProviderProvider._();

/// 切换主题服务 [appThemeModeProvider]
final class AppThemeModeProviderProvider
    extends $AsyncNotifierProvider<AppThemeModeProvider, ThemeMode> {
  /// 切换主题服务 [appThemeModeProvider]
  const AppThemeModeProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'appThemeModeProvider',
        isAutoDispose: false,
        dependencies: const <ProviderOrFamily>[appConfigProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          AppThemeModeProviderProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = appConfigProvider;

  @override
  String debugGetCreateSourceHash() => _$appThemeModeProviderHash();

  @$internal
  @override
  AppThemeModeProvider create() => AppThemeModeProvider();
}

String _$appThemeModeProviderHash() =>
    r'f5b689ca81cff8d18d6e3ea9cef848c500f156d9';

/// 切换主题服务 [appThemeModeProvider]

abstract class _$AppThemeModeProvider extends $AsyncNotifier<ThemeMode> {
  FutureOr<ThemeMode> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<ThemeMode>, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<ThemeMode>, ThemeMode>,
              AsyncValue<ThemeMode>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
