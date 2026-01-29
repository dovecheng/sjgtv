// import 'package:android_id/android_id.dart';
import 'package:base/device_info.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter_device_id/flutter_device_id.dart';

/// 设备唯一Id
///
/// iOS以应用安装为依据, 非真实设备ID
final Future<String?> $deviceId = FlutterDeviceId().getDeviceId();

/// 设备信息
///
/// android日志:
/// ```
/// {
///   "product": "xpeng_retcn",
///   "supportedAbis": [
///     "arm64-v8a",
///     "armeabi-v7a",
///     "armeabi"
///   ],
///   "serialNumber": "unknown",
///   "displayMetrics": {
///     "xDpi": 397.56500244140625,
///     "widthPx": 1080.0,
///     "heightPx": 2460.0,
///     "yDpi": 397.98699951171875
///   },
///   "supported32BitAbis": [
///     "armeabi-v7a",
///     "armeabi"
///   ],
///   "display": "S3RXC32.33-8-7",
///   "type": "user",
///   "isPhysicalDevice": true,
///   "version": {
///     "baseOS": "",
///     "securityPatch": "2022-12-01",
///     "sdkInt": 31,
///     "release": "12",
///     "codename": "REL",
///     "previewSdkInt": 0,
///     "incremental": "eece4-8868d4"
///   },
///   "systemFeatures": [
///     "android.hardware.sensor.proximity",
///     "com.motorola.mototour",
///     "com.motorola.help.extlog",
///     "com.motorola.software.game_mode",
///     ...100+
///   ],
///   "manufacturer": "motorola",
///   "tags": "release-keys",
///   "supported64BitAbis": [
///     "arm64-v8a"
///   ],
///   "bootloader": "MBM-3.0-xpeng_retcn-fa2cdb98687-221206",
///   "fingerprint": "motorola/xpeng_retcn/xpeng:12/S3RXC32.33-8-7/eece4-8868d4:user/release-keys",
///   "host": "gcbuilds-e2-32-128-def-203-e5a8ye",
///   "model": "XT2175-2",
///   "id": "S3RXC32.33-8-7", // 型号
///   "brand": "motorola",
///   "device": "xpeng",
///   "board": "xpeng",
///   "hardware": "qcom"
/// }
/// ```
///
/// iPad日志:
/// ```
/// {
///   "systemName": "iPadOS",
///   "isPhysicalDevice": "true",
///   "utsname": {
///     "release": "22.4.0",
///     "sysname": "Darwin",
///     "nodename": "MrctekiiPad",
///     "machine": "iPad7,5",
///     "version": "Darwin Kernel Version 22.4.0: Mon Mar  6 20:42:14 PST 2023; root:xnu-8796.102.5~1/RELEASE_ARM64_T8010"
///   },
///   "model": "iPad",
///   "localizedModel": "iPad",
///   "systemVersion": "16.4.1",
///   "name": "iPad",
///   "identifierForVendor": "1B09BAB0-5563-4011-B0F3-562AAA87EDF2"
/// }
/// ```
final Future<BaseDeviceInfo> $deviceInfo = DeviceInfoPlugin().deviceInfo;

final Future<Map<String, dynamic>> $deviceInfoMap = $deviceInfo.then(
  (info) async => {
    'deviceId': await $deviceId,
    'type': info.type.name,
    if (info is WebBrowserInfo) ...{
      'deviceMemory': info.deviceMemory,
      'hardwareConcurrency': info.hardwareConcurrency,
      'maxTouchPoints': info.maxTouchPoints,
      'platform': info.platform,
      'product': info.product,
      'productSub': info.productSub,
      'userAgent': info.userAgent,
      'vendor': info.vendor,
      'vendorSub': info.vendorSub,
    } else if (info is AndroidDeviceInfo) ...{
      // 'deviceId': await AndroidId().getId(),
      'version': info.version.release,
      'brand': info.brand,
      'id': info.id,
      'manufacturer': info.manufacturer,
      'model': info.model,
      'isPhysicalDevice': info.isPhysicalDevice,
    } else if (info is IosDeviceInfo) ...{
      // 'deviceId': info.identifierForVendor,
      // 'identifierForVendor': info.identifierForVendor,
      'isPhysicalDevice': info.isPhysicalDevice,
      'model': info.utsname.machine,
      'systemVersion': info.systemVersion,
    } else if (info is LinuxDeviceInfo) ...{
      'buildId': info.buildId,
      'id': info.id,
      'idLike': info.idLike,
      'machineId': info.machineId,
      'name': info.name,
      'prettyName': info.prettyName,
      'variant': info.variant,
      'variantId': info.variantId,
      'version': info.version,
      'versionCodename': info.versionCodename,
      'versionId': info.versionId,
    } else if (info is MacOsDeviceInfo) ...{
      'activeCPUs': info.activeCPUs,
      'arch': info.arch,
      'computerName': info.computerName,
      'cpuFrequency': info.cpuFrequency,
      'hostName': info.hostName,
      'kernelVersion': info.kernelVersion,
      'memorySize': info.memorySize,
      'model': info.model,
      'osRelease': info.osRelease,
      'systemGUID': info.systemGUID,
    } else if (info is WindowsDeviceInfo) ...{
      'computerName': info.computerName,
      'numberOfCores': info.numberOfCores,
      'systemMemoryInMegabytes': info.systemMemoryInMegabytes,
    },
  },
);
