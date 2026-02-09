// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 设置提供者

@ProviderFor(SettingsProvider)
const settingsProvider = SettingsProviderProvider._();

/// 设置提供者
final class SettingsProviderProvider
    extends $AsyncNotifierProvider<SettingsProvider, Settings> {
  /// 设置提供者
  const SettingsProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'settingsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$settingsProviderHash();

  @$internal
  @override
  SettingsProvider create() => SettingsProvider();
}

String _$settingsProviderHash() => r'c0e1a62fea2e8c861859418b6a0ff6e24eaa779c';

/// 设置提供者

abstract class _$SettingsProvider extends $AsyncNotifier<Settings> {
  FutureOr<Settings> build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<AsyncValue<Settings>, Settings>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<Settings>, Settings>,
              AsyncValue<Settings>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
