import 'package:base/extension.dart';
import 'package:base/log.dart';

void main() {
  Log log = Log('test_trim');

  String test1 = '''
  1
  2
    3''';

  String test2 = '''
  |1
  |2
  |  3''';

  log.d('test1: \n${test1.trimIndent()}');

  log.d('test2: \n${test2.trimMargin()}');
}
