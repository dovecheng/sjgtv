import 'package:device_info_plus/device_info_plus.dart';

enum DeviceType { unknown, web, android, iOS, linux, macOS, windows }

extension BaseDeviceInfoExt on BaseDeviceInfo {
  DeviceType get type => switch (this) {
    WebBrowserInfo _ => DeviceType.web,
    AndroidDeviceInfo _ => DeviceType.android,
    IosDeviceInfo _ => DeviceType.iOS,
    LinuxDeviceInfo _ => DeviceType.linux,
    MacOsDeviceInfo _ => DeviceType.macOS,
    WindowsDeviceInfo _ => DeviceType.windows,
    _ => DeviceType.unknown,
  };

  /// 是否为物理设备, 仅支持iOS和Android
  bool? get isPhysical => switch (this) {
    AndroidDeviceInfo it => it.isPhysicalDevice,
    IosDeviceInfo it => it.isPhysicalDevice,
    _ => null,
  };

  /// 获取系统SDK版本, 仅支持安卓
  ///
  /// | 名称                              | API 级别 |
  /// | -------------------------------- | -------- |
  /// | Android 15.0 ("VanillalceCream") | 34       |
  /// | Android 14.0 ("UpsideDownCake")  | 34       |
  /// | Android 13.0 ("Tiramisu")        | 33       |
  /// | Android 12L ("Sv2")              | 32       |
  /// | Android 12.0 ("S")               | 31       |
  /// | Android 11.0 ("R")               | 30       |
  /// | Android 10.0 ("Q")               | 29       |
  /// | Android 9.0 ("Pie")              | 28       |
  /// | Android 8.1 ("Oreo")             | 27       |
  /// | Android 8.0 ("Oreo")             | 26       |
  /// | Android 7.1.1 ("Nougat")         | 25       |
  /// | Android 7.0 ("Nougat")           | 24       |
  /// | Android 6.0 ("Marshmallow")      | 23       |
  /// | Android 5.1 ("Lollipop")         | 22       |
  /// | Android 5.0 ("Lollipop")         | 21       |
  int? get androidSdkInt => switch (this) {
    AndroidDeviceInfo it => it.version.sdkInt,
    _ => null,
  };

  int get androidSdkIntOrZero => androidSdkInt ?? 0;
}

extension FutureBaseDeviceInfoExt on Future<BaseDeviceInfo> {
  /// 异步获取设备类型
  Future<DeviceType> get type => then((it) => it.type);

  /// 异步判断是否为物理设备
  Future<bool?> get isPhysical => then((it) => it.isPhysical);

  /// 异步获取安卓系统 SDK 版本
  Future<int?> get androidSdkInt => then((it) => it.androidSdkInt);

  /// 异步获取安卓系统 SDK 版本 或 0
  Future<int> get androidSdkIntOrZero => then((it) => it.androidSdkIntOrZero);
}
