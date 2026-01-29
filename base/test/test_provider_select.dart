import 'package:base/base.dart';
import 'package:riverpod/riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'test_provider_select.g.dart';

final Log log = Log('test_provider_watch');

@Riverpod(keepAlive: true)
class TestProvider extends _$TestProvider {
  @override
  Map<String, dynamic> build() => {'value': 0};

  void increase() {
    state['value']++;
    ref.notifyListeners();
  }

  void decrease() {
    state['value']--;
    state['test'] = true;
    ref.notifyListeners();
  }
}

Future<void> main() async {
  $ref.listen(testProvider, (
    Map<String, dynamic>? previous,
    Map<String, dynamic> next,
  ) {
    log.d(() => 'listen value=$next');
  });

  $ref.listen(
    testProvider.select<bool>(
      (Map<String, dynamic> value) => value['test'] ?? false,
    ),
    (bool? previous, bool next) {
      log.d(() => 'select value=$next');
    },
  );

  Map<String, dynamic> value = $ref.read(testProvider);
  log.d(() => 'read value=$value');

  $ref.read(testProvider.notifier).increase();
  $ref.read(testProvider.notifier).decrease();

  await Future<void>.delayed(const Duration(seconds: 5));
  log.d(() => 'end');
}
