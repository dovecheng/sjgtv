import 'package:base/app.dart';
import 'package:base/snake_bar.dart';
import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

enum NotificationSnakeBarType { error, info, success }

/// SnakeBar
abstract final class NotificationSnakeBar {
  /// 展示Error通知
  static void showError({required String message, String? messageKey}) {
    showWidget(CustomSnackBar.error(message: message, messageKey: messageKey));
  }

  /// 展示普通通知
  static void showInfo({required String message, String? messageKey}) {
    showWidget(CustomSnackBar.info(message: message, messageKey: messageKey));
  }

  /// 展示Success通知
  static void showSuccess({required String message, String? messageKey}) {
    showWidget(
      CustomSnackBar.success(message: message, messageKey: messageKey),
    );
  }

  /// 展示提示[message]
  ///
  /// [type]提示类型
  static void showMessage({
    required String message,
    required NotificationSnakeBarType type,
    String? messageKey,
  }) {
    switch (type) {
      case NotificationSnakeBarType.error:
        showError(message: message, messageKey: messageKey);
        break;
      case NotificationSnakeBarType.info:
        showInfo(message: message, messageKey: messageKey);
        break;
      case NotificationSnakeBarType.success:
        showSuccess(message: message, messageKey: messageKey);
        break;
    }
  }

  static void showWidget(Widget child) {
    showTopSnackBar(
      AppNavigator.overlay,
      SafeArea(
        child: Padding(padding: const EdgeInsets.all(16), child: child),
      ),
    );
  }
}
