import 'package:sjgtv/core/log/log.dart';

extension ObjectLogExt on Object {
  /// 使用对象的类型作为名称返回日志记录器实例.
  Log get log => Log((this is Type ? this as Type : runtimeType).toString());

  String get shortHash =>
      hashCode.toUnsigned(20).toRadixString(16).padLeft(5, '0');

  String get describeIdentity => '$runtimeType#$shortHash';
}
