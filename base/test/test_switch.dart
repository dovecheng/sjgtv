import 'package:base/log.dart';

void main() {
  Log log = Log('test_switch');

  Object code = "200";
  String result = switch (code) {
    num it => 'num $it',
    String it => 'String $it',
    _ => 'null',
  };
  log.d(() => 'result=$result');

  log.d(() => 'test1');
  Object object = 123;
  switch (object) {
    case int it when it >= 0:
      log.d(() => 'i >= 0');
    case int _:
      log.d(() => 'i is int');
    default:
      log.d(() => 'default');
  }

  log.d(() => 'test2');
  switch (1) {
    case 1:
    case 2:
    case 3:
      log.d(() => '3');
      log.d(() => '3');
  }

  log.d(() => 'test3');
  switch (3) {
    case 2:
      log.d(() => '2');
    case 3:
      log.d(() => '3');
    // dart3 分支语句不需要写 break;
    // break;
    case 4:
      // dart3 不会执行这句代码
      log.d(() => '4');
  }

  log.d(() => 'test4');
  dynamic json = <String, List<Object>>{
    'user': ['Lily', 13],
  };
  json = <Map<String, String>>[
    {'key': 'key1', 'value': 'value1'},
    {'key': 'key2', 'value': 'value2'},
  ];
  switch (json) {
    case Iterable<Object> it when it.runtimeType == (List<Map<String, String>>):
      log.d(() => 'List<Map<String, String>>');
    case {'user': [String name, int age]}:
      log.d(() => '$name $age');
    case [{'key': String key, 'value': String value}, ...List<Object> more]:
      log.d(() => '[{}, ...] $key $value $more');
    case [Object a, Object b]:
      log.d(() => '[a, b] $a $b');
    case [...List<Object> items]:
      log.d(() => '[...] $items');
  }
}
