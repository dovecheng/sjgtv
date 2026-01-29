import 'package:base/log.dart';

Future<T> test<T>([Object? object]) => Future.value(object as T);

Future<void> main() async {
  Log log = Log('test_generics_case');
  await test<void>(123);
  log.d(() async => 'main: ${test<void>(321)}');
  log.d(() async => 'main: ${await test<String>('123')}');
}
