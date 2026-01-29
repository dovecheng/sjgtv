import 'package:base/base.dart';

void main() {
  Log log = Log('test_regexp');
  int count = 100000;
  String source = r'[-_]\w+';

  Stopwatch stopwatch = Stopwatch()..start();
  RegExp regExp = RegExp(source);
  for (int i = 0; i < count; i++) {
    regExp.hasMatch('123');
  }
  stopwatch.stop();
  log.d(() => 'elapsedMilliseconds = ${stopwatch.elapsedMilliseconds}');

  stopwatch
    ..reset()
    ..start();
  for (int i = 0; i < count; i++) {
    RegExp regExp = RegExp(source);
    regExp.hasMatch('123');
  }
  stopwatch.stop();
  log.d(() => 'elapsedMilliseconds = ${stopwatch.elapsedMilliseconds}');
}
