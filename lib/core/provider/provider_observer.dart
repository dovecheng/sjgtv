import 'package:sjgtv/core/log/log.dart';
import 'package:riverpod/riverpod.dart';

/// ProviderObserver listens to the changes of a ProviderContainer.
///
/// see also: https://docs-v2.riverpod.dev/docs/concepts/provider_observer/
final class BaseProviderObserver extends ProviderObserver {
  static BaseProviderObserver? _instance;

  /// 需要忽略更新日志的 provider 列表
  ///
  /// Riverpod 3 中对 Provider 的基础类型做了重构，这里只关心“身份”，
  /// 因此使用 [Object] 存储即可。
  final Set<Object> updateFilter = {};

  factory BaseProviderObserver() => _instance ??= BaseProviderObserver._();

  BaseProviderObserver._();

  @override
  void didAddProvider(ProviderObserverContext context, Object? value) => log.v(
    () async =>
        'provider=${context.provider.describeIdentity} value=${value?.describeIdentity}',
  );

  @override
  void didDisposeProvider(ProviderObserverContext context) =>
      log.v(() async => 'provider=${context.provider.describeIdentity}');

  @override
  void didUpdateProvider(
    ProviderObserverContext context,
    Object? previousValue,
    Object? newValue,
  ) {
    if (newValue is AsyncError) {
      log.w(
        () async => 'provider=${context.provider.describeIdentity}',
        newValue.error,
        newValue.stackTrace,
      );
    } else if (!updateFilter.contains(context.provider)) {
      log.v(
        () async =>
            'provider=${context.provider.describeIdentity} previousValue=${previousValue?.describeIdentity} newValue=${newValue?.describeIdentity}',
      );
    }
  }

  @override
  void providerDidFail(
    ProviderObserverContext context,
    Object error,
    StackTrace stackTrace,
  ) => log.e(
    () async => 'provider=${context.provider.describeIdentity}',
    error,
    stackTrace,
  );
}
