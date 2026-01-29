import 'package:base/log.dart';

final Log log = Log('test_generics_matching');

int test(Object object) => switch (object) {
  bool _ || num _ || String _ => 1,
  Iterable<dynamic> _ => 2,
  Map<dynamic, dynamic> _ => 3,
  _ => -1,
};

void main() {
  log.d(() => '${test(1)}');
  log.d(() => '${test([1, 2, 3])}');
  log.d(() => '${test({1: 2})}');
}
