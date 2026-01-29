// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_config_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 应用配置提供者 [appConfigProvider]

@ProviderFor(AppConfigProvider)
const appConfigProvider = AppConfigProviderFamily._();

/// 应用配置提供者 [appConfigProvider]
final class AppConfigProviderProvider
    extends $AsyncNotifierProvider<AppConfigProvider, dynamic> {
  /// 应用配置提供者 [appConfigProvider]
  const AppConfigProviderProvider._({
    required AppConfigProviderFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'appConfigProvider',
         isAutoDispose: false,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$appConfigProviderHash();

  @override
  String toString() {
    return r'appConfigProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  AppConfigProvider create() => AppConfigProvider();

  @override
  bool operator ==(Object other) {
    return other is AppConfigProviderProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$appConfigProviderHash() => r'047c178f92c32ba3ef05885a28ba45527459e64e';

/// 应用配置提供者 [appConfigProvider]

final class AppConfigProviderFamily extends $Family
    with
        $ClassFamilyOverride<
          AppConfigProvider,
          AsyncValue<dynamic>,
          dynamic,
          FutureOr<dynamic>,
          String
        > {
  const AppConfigProviderFamily._()
    : super(
        retry: null,
        name: r'appConfigProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: false,
      );

  /// 应用配置提供者 [appConfigProvider]

  AppConfigProviderProvider call(String key) =>
      AppConfigProviderProvider._(argument: key, from: this);

  @override
  String toString() => r'appConfigProvider';
}

/// 应用配置提供者 [appConfigProvider]

abstract class _$AppConfigProvider extends $AsyncNotifier<dynamic> {
  late final _$args = ref.$arg as String;
  String get key => _$args;

  FutureOr<dynamic> build(String key);
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build(_$args);
    final ref = this.ref as $Ref<AsyncValue<dynamic>, dynamic>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<dynamic>, dynamic>,
              AsyncValue<dynamic>,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
