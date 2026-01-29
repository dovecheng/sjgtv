import 'dart:async';

import 'package:base/log.dart';

Future<void> main() async {
  Log log = Log('test_stream');
  StreamController<int> controller = StreamController<int>.broadcast();
  test(controller.stream);
  controller.add(1);
  await Future<void>.delayed(const Duration(seconds: 1));
  controller.add(2);
  await Future<void>.delayed(const Duration(seconds: 1));
  controller.close();
  log.d(() => 'end');
}

Future<void> test(Stream<int> stream) async {
  Log log = Log('test_stream');
  await for (int e in stream) {
    log.d(() => '$e');
  }
  log.d(() => 'end');
  await Future<void>.delayed(const Duration(seconds: 1));
  test(stream);
}
