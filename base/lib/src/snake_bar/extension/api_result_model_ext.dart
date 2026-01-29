import 'package:base/api.dart';
import 'package:base/snake_bar.dart';

/// 展示提示信息
extension ApiResultDialogExtension on ApiResultModel {
  /// 展示成功或错误信息
  void showSuccessOrErrorMessage() {
    if (isSuccessAndHasMessage) {
      NotificationSnakeBar.showSuccess(message: message!);
    } else if (isErrorAndHasMessage) {
      NotificationSnakeBar.showError(message: message!);
    }
  }

  /// 展示成功信息
  void showSuccessMessage() {
    if (isSuccessAndHasMessage) {
      NotificationSnakeBar.showSuccess(message: message!);
    }
  }

  /// 展示错误信息
  void showErrorMessage() {
    if (isErrorAndHasMessage) {
      NotificationSnakeBar.showError(message: message!);
    }
  }
}
