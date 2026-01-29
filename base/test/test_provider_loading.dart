import 'package:base/log.dart';
import 'package:base/provider.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'test_provider_loading.g.dart';

@Riverpod(keepAlive: true)
class TestProvider extends _$TestProvider {
  @override
  Future<int> build() async {
    await Future<void>.delayed(const Duration(seconds: 1));
    return 0;
  }

  Future<void> test() async {
    // waiting future
    state = const AsyncValue<int>.loading();
    await Future<void>.delayed(const Duration(seconds: 1));
    state = const AsyncValue<int>.data(1);
  }
}

Future<void> main() async {
  Log log = Log('test_provider_loading');

  configRef(overrides: [testProvider.overrideWith(() => TestProvider())]);

  log.d(() => '1 ${$ref.read(testProvider).value}');
  log.d(() async => '2 ${await $ref.read(testProvider.future)}');

  await Future<void>.delayed(const Duration(seconds: 2));

  $ref.read(testProvider.notifier).test();
  log.d(() => '3 ${$ref.read(testProvider).value}');
  log.d(() async => '4 ${await $ref.read(testProvider.future)}');

  await Future<void>.delayed(const Duration(seconds: 3));

  log.d(() => '5 ${$ref.read(testProvider).value}');
  log.d(() async => '6 ${await $ref.read(testProvider.future)}');
}
