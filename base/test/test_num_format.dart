import 'package:base/base.dart';

void main() {
  Log log = Log('test_num_format');
  log.d(() => 0.1.format(style: '00'));
  log.d(() => 1.1.format(style: '00'));
  log.d(() => 11.1.format(style: '00'));
}
