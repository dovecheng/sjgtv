import 'package:base/provider.dart';
import 'package:riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';

ProviderContainer _ref = ProviderContainer(observers: [BaseProviderObserver()]);

/// [Riverpod 文档](https://riverpod.dev/)
///
/// [为什么要使用提供者?](https://docs-v2.riverpod.dev/docs/concepts/providers#why-use-providers)
///
/// 简单配置方式
/// ```dart
/// runApp(ProviderScope(
///   parent: rootRef,
///   overrides: [
///     xxxProvider.overrideWith(Provider<X>((ref) {
///       // ...
///     })),
///     xxxProvider.overrideWithValue(value),
///   ],
///   child: MyApp(),
/// ));
/// ```
///
/// 过渡阶段配置方式
/// ```dart
/// configRootRef(overrides: [
///   xxxProvider.overrideWith(Provider<X>((ref) {
///     // ...
///   })),
///   xxxProvider.overrideWithValue(value),
/// ]);
/// runApp(UncontrolledProviderScope(
///   container: rref,
///   child: MyApp(),
/// ));
/// ```
ProviderContainer get $ref => _ref;

void configRef({
  List<Override> overrides = const [],
  List<ProviderObserver>? observers,
}) => _ref = ProviderContainer(
  parent: _ref,
  observers: observers,
  overrides: overrides,
);
