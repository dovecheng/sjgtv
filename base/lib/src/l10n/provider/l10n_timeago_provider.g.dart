// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'l10n_timeago_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// 根据系统 locale 设置 timeago 的默认语言，供 [L10nDateTimeFormatExt.formatTimeAgo] 使用。
///
/// 应在应用启动时读取一次（如 [AppRunner.initProvider] 中），
/// 之后 [timeago.format] 会使用已设置的 locale。

@ProviderFor(L10nTimeagoProvider)
const l10nTimeagoProvider = L10nTimeagoProviderProvider._();

/// 根据系统 locale 设置 timeago 的默认语言，供 [L10nDateTimeFormatExt.formatTimeAgo] 使用。
///
/// 应在应用启动时读取一次（如 [AppRunner.initProvider] 中），
/// 之后 [timeago.format] 会使用已设置的 locale。
final class L10nTimeagoProviderProvider
    extends $NotifierProvider<L10nTimeagoProvider, void> {
  /// 根据系统 locale 设置 timeago 的默认语言，供 [L10nDateTimeFormatExt.formatTimeAgo] 使用。
  ///
  /// 应在应用启动时读取一次（如 [AppRunner.initProvider] 中），
  /// 之后 [timeago.format] 会使用已设置的 locale。
  const L10nTimeagoProviderProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'l10nTimeagoProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

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
    r'66b81e0ed2407f0ab886e4aedaf7cf78b22e0f6d';

/// 根据系统 locale 设置 timeago 的默认语言，供 [L10nDateTimeFormatExt.formatTimeAgo] 使用。
///
/// 应在应用启动时读取一次（如 [AppRunner.initProvider] 中），
/// 之后 [timeago.format] 会使用已设置的 locale。

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
