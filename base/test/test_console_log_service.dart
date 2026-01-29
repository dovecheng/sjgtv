import 'package:base/log.dart';

Future<void> main() async {
  // 获取日志记录器, 如果是对象直接使用log属性获取
  Log log = Log('test_log_service');

  // 日志级别打印, message支持无参方法和挂起函数或字符串
  // log.v(() {
  //   throw '123123';
  //   return '';
  // });
  log.d(null);
  log.i(null);
  log.w(null);
  log.v(null);
  log.v(() => null);
  log.d('');
  log.d(() => null);
  // log.e(() {
  //   throw '321321';
  //   return null;
  // });
}
