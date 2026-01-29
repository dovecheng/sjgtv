import 'package:base/log.dart';

Future<void> main() async {
  Log log = Log('test_binary');

  log.d(() => '123');
  log.d(() => '123');
  log.d(() => '123');
  log.d(() => '123');

  log.d(() => (1 << 0 | 1 << 1 | 1 << 3 | 1 << 5).toRadixString(2));
  log.d(() => '${int.parse('101011', radix: 2) & 1 << 3 == 1 << 3}');
}
