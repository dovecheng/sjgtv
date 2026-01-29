import 'package:base/log.dart';

String test(String str) => str;

abstract class A {
  String test(String str);
}

class B extends A {
  @override
  dynamic noSuchMethod(Invocation invocation) {
    log.d(() => '${(invocation.memberName as dynamic)}');
    log.d(() => '${invocation.positionalArguments}');
    return invocation.positionalArguments.firstOrNull;
    // return super.noSuchMethod(invocation);
  }
}

void main() {
  Log log = Log('test_func');
  String Function(String str) func = test;
  log.d(() => '$func');

  B b = B();
  String str = b.test('123');
  log.d(() => str);

  func = b.test;
  log.d(() => '$func');
}
