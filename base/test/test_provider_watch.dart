import 'package:base/base.dart';

import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'test_provider_watch.g.dart';

final Log log = Log('test_provider_watch');

@Riverpod(keepAlive: true)
class Test1Provider extends _$Test1Provider {
  @override
  int build() {
    listenSelf((int? previous, int next) {
      log.d(() => 'previous=$previous next=$next');
    });
    return 0;
  }

  void increase() {
    state++;
  }

  void decrease() {
    state--;
  }
}

@Riverpod(keepAlive: true)
class Test2Provider extends _$Test2Provider {
  @override
  int build() => ref.watch(test1Provider);
}

Future<void> main() async {
  int value = $ref.read(test2Provider);
  log.d(() => 'test2Provider.value=$value');

  $ref.listen(test2Provider, (int? previous, int next) {
    log.d(() => 'test2Provider.value=$next');
  });

  $ref.read(test1Provider.notifier).increase();

  await Future<void>.delayed(const Duration(seconds: 3));
  log.d(() => 'end');
}
