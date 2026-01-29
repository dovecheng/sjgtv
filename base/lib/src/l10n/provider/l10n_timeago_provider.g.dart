// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'l10n_timeago_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(L10nTimeagoProvider)
const l10nTimeagoProvider = L10nTimeagoProviderProvider._();

final class L10nTimeagoProviderProvider
    extends $NotifierProvider<L10nTimeagoProvider, void> {
  const L10nTimeagoProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'l10nTimeagoProvider',
        isAutoDispose: false,
        dependencies: const <ProviderOrFamily>[l10nLanguageProvider],
        $allTransitiveDependencies: const <ProviderOrFamily>[
          L10nTimeagoProviderProvider.$allTransitiveDependencies0,
        ],
      );

  static const $allTransitiveDependencies0 = l10nLanguageProvider;

  @override
  String debugGetCreateSourceHash() => _$l10nTimeagoProviderHash();

  @$internal
  @override
  L10nTimeagoProvider create() => L10nTimeagoProvider();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(void value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<void>(value),
    );
  }
}

String _$l10nTimeagoProviderHash() =>
    r'5b6857b5a1a6ecfdb93e9b3594b63a0c3a2ac273';

abstract class _$L10nTimeagoProvider extends $Notifier<void> {
  void build();
  @$mustCallSuper
  @override
  void runBuild() {
    build();
    final ref = this.ref as $Ref<void, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<void, void>,
              void,
              Object?,
              Object?
            >;
    element.handleValue(ref, null);
  }
}
