import 'dart:async';

import 'package:base/api.dart';
import 'package:base/app.dart';
import 'package:base/log.dart';
import 'package:base/widget.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

/// 加载中对话框
class LoadingDialog extends StatelessWidget {
  @visibleForTesting
  static final Log log = (LoadingDialog).log;

  const LoadingDialog({super.key});

  @override
  Widget build(BuildContext context) => const Center(
    child: Card(
      child: Padding(
        padding: EdgeInsets.all(16),
        child: CircularProgressIndicator(),
      ),
    ),
  );

  /// 显示加载中对话框
  ///
  /// * [future] 异步任务
  /// * [onResult] 结果回调, 和挂起结果一样
  /// * [onSuccess] 成功回调, 和挂起结果一样
  /// * [onError] 错误回调, 若挂起会被抛出异常.
  /// * [onCancel] 取消回调, 如已完成请求则不会被取消.
  /// * [cancelToken] 用于取消请求的令牌
  /// * [hideSortInout] 是否隐藏软键盘, 默认隐藏
  static Future<T> show<T>({
    required Future<T> future,
    void Function(T result)? onResult,
    void Function(T result)? onSuccess,
    void Function(Object error)? onError,
    void Function()? onCancel,
    CancelToken? cancelToken,
    bool hideSortInout = true,
  }) {
    if (hideSortInout) {
      KeyboardHider.hideTextInput();
    }

    log.d(() => 'start ${future.runtimeType}');
    bool showing = true;
    bool cancelable = true;

    bool barrierDismissible = cancelToken != null || onCancel != null;
    showDialog<T>(
      context: AppNavigator.context,
      builder: (BuildContext context) =>
          PopScope(canPop: barrierDismissible, child: const LoadingDialog()),
      barrierDismissible: barrierDismissible,
    ).then((T? result) {
      showing = false;

      // by: navigator.pop(value);
      if (result != null) {
        onResult?.call(result);

        if (result is ApiResultModel) {
          if (result.isSuccess) {
            onSuccess?.call(result);
          } else if (result.isCancelError) {
            onCancel?.call();
          } else if (result.isError) {
            onError?.call(result);
          }
        } else {
          onSuccess?.call(result);
        }

        log.d(() {
          if (result is ApiResultModel) {
            return 'end, result.isSuccess=${result.isSuccess}';
          }
          return 'end, result is ${result.runtimeType}';
        });
      } else if (cancelable) {
        // by dismiss
        if (cancelToken != null) {
          cancelToken.cancel();
        } else {
          onCancel?.call();
        }
        log.d(() => 'canceling');
      }
    });

    return future.then(
      (T value) {
        if (showing) {
          // 关闭对话框 成功
          AppNavigator.navigator.pop(value);
        }
        return value;
      },
      onError: (Object error) {
        if (showing) {
          cancelable = false;

          // 关闭对话框 错误
          AppNavigator.navigator.pop();
        }

        // 取消请求或400~500错误会被拦截器转换, 一般只会出现在代码异常时回调
        if (error is DioException && error.type == DioExceptionType.cancel) {
          log.v(() => 'canceled');
          onCancel?.call();
        } else {
          log.d(() => 'errored', error);
          onError?.call(error);
        }
      },
    );
  }
}
