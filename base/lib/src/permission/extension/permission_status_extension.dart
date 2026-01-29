import 'package:permission_handler/permission_handler.dart';

/// 枚举值说明:
///
/// [denied]
/// 用户拒绝了访问所请求功能的权限，需要先询问权限。
///
/// [granted]
/// 用户授予了访问所请求功能的权限。
///
/// [restricted]
/// 操作系统拒绝了访问所请求功能的权限。用户无法更改此应用的状态，可能是由于启用了某些限制，例如家长控制。
/// 仅支持 iOS。
///
/// [limited]
/// 用户已授权此应用程序有限访问。到目前为止，这只与照片库选择器相关。
/// 仅支持 iOS（iOS 14+）和 Android（Android 14+）。
///
/// [permanentlyDenied]
/// 对所请求功能的权限被永久拒绝，请求此权限时不会显示权限对话框。用户仍然可以在设置中更改权限状态。
/// 在 Android 上：
/// Android 11+（API 30+）：用户第二次拒绝权限。
/// 低于 Android 11（API 30）：用户拒绝了访问所请求功能并选择不再显示请求。
/// 在 iOS 上：
/// 如果用户拒绝了访问所请求功能。
///
/// [provisional]
/// 应用程序被临时授权发布非中断性用户通知。
/// 仅支持 iOS（iOS 12+）。
extension PermissionStatusExt on PermissionStatus {
  /// 判断权限是否被授予或者被有限授予
  bool get isGrantedOrLimited => isGranted || isLimited;
}

extension FuturePermissionStatusExt on Future<PermissionStatus> {
  /// 判断权限是否被授予或者被有限授予
  Future<bool> get isGrantedOrLimited =>
      then((status) => status.isGrantedOrLimited);
}
