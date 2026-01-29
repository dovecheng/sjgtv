import 'package:retrofit/dio.dart';

class ApiExtrasModel extends TypedExtras {
  /// 是否为 mock 接口
  final bool isMock;

  /// 是否打印日志
  final bool isLog;

  /// 是否打印数据
  final bool isLogData;

  const ApiExtrasModel({
    this.isMock = false,
    this.isLog = true,
    this.isLogData = true,
  }) : assert(isLogData && isLog || !isLogData);
}
