// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'text_scale_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 字体缩放因子 [textScaleProvider]
///
/// ```dart
/// // get text scale
/// double textScale = $ref.read(textScaleProvider);
///
/// // change text scale
/// $ref.read(textScaleProvider.notifier).saveOrUpdate(1.5);
/// ```

@ProviderFor(TextScaleProvider)
const textScaleProvider = TextScaleProviderProvider._();

/// 字体缩放因子 [textScaleProvider]
///
/// ```dart
/// // get text scale
/// double textScale = $ref.read(textScaleProvider);
///
/// // change text scale
/// $ref.read(textScaleProvider.notifier).saveOrUpdate(1.5);
/// ```
final class TextScaleProviderProvider
    extends $NotifierProvider<TextScaleProvider, double> {
  /// 字体缩放因子 [textScaleProvider]
  ///
  /// ```dart
  /// // get text scale
  /// double textScale = $ref.read(textScaleProvider);
  ///
  /// // change text scale
  /// $ref.read(textScaleProvider.notifier).saveOrUpdate(1.5);
  /// ```
  const TextScaleProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'textScaleProvider',
        isAutoDispose: false,
        dependencies: const <ProviderOrFamily>[appConfigProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          TextScaleProviderProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = appConfigProvider;

  @override
  String debugGetCreateSourceHash() => _$textScaleProviderHash();

  @$internal
  @override
  TextScaleProvider create() => TextScaleProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(double value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<double>(value),
    );
  }
}

String _$textScaleProviderHash() => r'18fe31d7d37f95112e0f4ad92dba75ce168acdf5';

/// 字体缩放因子 [textScaleProvider]
///
/// ```dart
/// // get text scale
/// double textScale = $ref.read(textScaleProvider);
///
/// // change text scale
/// $ref.read(textScaleProvider.notifier).saveOrUpdate(1.5);
/// ```

abstract class _$TextScaleProvider extends $Notifier<double> {
  double build();
  @$mustCallSuper
  @override
  void runBuild() {
    final created = build();
    final ref = this.ref as $Ref<double, double>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<double, double>,
              double,
              Object?,
              Object?
            >;
    element.handleValue(ref, created);
  }
}
