import 'package:base/log.dart';

void main() {
  Log log = Log('test_object');
  log.d(() => '${Object() == Object()}');
  log.d(() => '${Object() == const Object()}');
  log.d(() => '${const Object() == const Object()}');
}
