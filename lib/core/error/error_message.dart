import 'package:flutter/material.dart';
import 'package:sjgtv/core/app/app.dart';
import 'package:sjgtv/l10n_gen/app_localizations.dart';
import 'package:sjgtv/core/network/network_status.dart';

/// 错误信息数据类
class ErrorInfo {
  final String title;
  final String message;
  final String? suggestion;
  final IconData icon;

  const ErrorInfo({
    required this.title,
    required this.message,
    this.suggestion,
    required this.icon,
  });
}

/// 错误提示工具类

///

/// 提供统一的错误消息格式和用户友好的错误说明

class ErrorMessage {

  /// 获取本地化实例

  static AppLocalizations get _l10n => AppLocalizations.of(AppNavigator.context);

  /// 获取网络状态实例
  static NetworkStatus get _network => NetworkStatus.instance;

  /// 获取错误信息
  static ErrorInfo getErrorInfo(String errorCode) {
    switch (errorCode) {
      // 网络连接错误
      case 'connectionError':
        return ErrorInfo(
          title: _l10n.apiConnectionError,
          message: _l10n.apiConnectionError,
          suggestion: _l10n.apiConnectionTimeout, // 使用现有的提示
          icon: Icons.cloud_off,
        );

      // 连接超时
      case 'connectionTimeout':
        return ErrorInfo(
          title: _l10n.apiConnectionTimeout,
          message: _l10n.apiConnectionTimeout,
          suggestion: _network.isOnline ? '请检查网络连接后重试' : '请检查网络连接',
          icon: Icons.timer,
        );

      // 发送超时
      case 'sendTimeout':
        return ErrorInfo(
          title: _l10n.apiSendTimeout,
          message: _l10n.apiSendTimeout,
          suggestion: '请稍后重试',
          icon: Icons.timer,
        );

      // 接收超时
      case 'receiveTimeout':
        return ErrorInfo(
          title: _l10n.apiReceiveTimeout,
          message: _l10n.apiReceiveTimeout,
          suggestion: '请稍后重试',
          icon: Icons.timer,
        );

      // SSL 证书错误
      case 'badCertificate':
        return ErrorInfo(
          title: _l10n.apiBadCertificate,
          message: _l10n.apiBadCertificate,
          suggestion: '请稍后重试或联系管理员',
          icon: Icons.security,
        );

      // 服务器响应错误
      case 'badResponse':
        return ErrorInfo(
          title: _l10n.apiBadResponse,
          message: _l10n.apiBadResponse,
          suggestion: '请稍后重试',
          icon: Icons.error_outline,
        );

      // 数据格式错误
      case 'formatError':
      case 'parseError':
        return ErrorInfo(
          title: _l10n.apiFormatError,
          message: _l10n.apiFormatError,
          suggestion: '请稍后重试',
          icon: Icons.description,
        );

      // 未知错误
      default:
        return ErrorInfo(
          title: _l10n.apiUnknownError,
          message: _l10n.apiUnknownError,
          suggestion: '请稍后重试',
          icon: Icons.error_outline,
        );
    }
  }

  /// 显示错误对话框
  static void showErrorDialog(BuildContext context, String errorCode) {
    final errorInfo = getErrorInfo(errorCode);

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(errorInfo.icon, size: 48, color: Colors.red),
        title: Text(errorInfo.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(errorInfo.message),
            if (errorInfo.suggestion != null) ...[
              const SizedBox(height: 16),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.info_outline, size: 16, color: Colors.blue),
                  const SizedBox(width: 8),
                  Expanded(child: Text(errorInfo.suggestion!)),
                ],
              ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('重试'),
          ),
        ],
      ),
    );
  }

  /// 显示错误 Snackbar
  static void showErrorSnackbar(
    BuildContext context,
    String errorCode, {
    Duration duration = const Duration(seconds: 3),
  }) {
    final errorInfo = getErrorInfo(errorCode);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            Icon(errorInfo.icon, size: 20, color: Colors.white),
            const SizedBox(width: 12),
            Expanded(child: Text(errorInfo.message)),
          ],
        ),
        duration: duration,
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.red.shade900,
        action: SnackBarAction(
          label: '重试',
          textColor: Colors.white,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  /// 获取离线提示信息
  static ErrorInfo getOfflineInfo() {
    return ErrorInfo(
      title: _l10n.offlineTitle,
      message: _l10n.offlineMessage,
      suggestion: _l10n.offlineSuggestion,
      icon: Icons.wifi_off,
    );
  }

  /// 显示离线提示
  static void showOfflineDialog(BuildContext context) {
    final offlineInfo = getOfflineInfo();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        icon: Icon(offlineInfo.icon, size: 48, color: Colors.orange),
        title: Text(offlineInfo.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(offlineInfo.message),
            const SizedBox(height: 16),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.info_outline, size: 16, color: Colors.blue),
                const SizedBox(width: 8),
                Expanded(child: Text(offlineInfo.suggestion!)),
              ],
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('确定'),
          ),
        ],
      ),
    );
  }
}
