import 'dart:async';

import 'package:sjgtv/core/log/log.dart';
import 'package:dio/dio.dart';
import 'package:riverpod/misc.dart';
import 'package:riverpod/riverpod.dart';

extension RefExt on Ref {
  /// 创建[Dio]取消令牌新实例, 销毁时取消请求.
  CancelToken cancelToken() {
    CancelToken cancelToken = CancelToken();
    onDispose(cancelToken.cancel);
    return cancelToken;
  }

  /// 在执行期间防止被销毁
  ///
  /// 注意: 使用这个方法将不会执行 onDispose(cancelToken.cancel);
  Future<T> keepAliveWith<T>(FutureOr<T> Function() callback) async {
    KeepAliveLink link = keepAlive();
    try {
      return await callback();
    } finally {
      link.close();
    }
  }

  /// 在指定时间段内防止被销毁
  ///
  /// 注意: 使用这个方法将不会执行 onDispose(cancelToken.cancel);
  KeepAliveLink keepAliveWithDuration<T>(Duration duration) {
    log.d(() => duration);
    KeepAliveLink link = keepAlive();
    Future<void>.delayed(duration).then((_) => link.close());
    return link;
  }
}
