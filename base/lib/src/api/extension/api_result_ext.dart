import 'package:base/api.dart';

/// ApiResultModel 的扩展，用于方便地复制对象并修改部分字段。
///
/// 示例：
/// ```dart
/// // 假设已有 ApiResultModel<User> result
/// ApiResultModel<User> copy1 = result.copyWith(message: "新消息");
/// ApiResultModel<String> copy2 = result.copyWith<String>(data: "字符串内容");
/// ```
/// 上述例子中：
/// - copy1 类型为 `ApiResultModel<User>`
/// - copy2 类型为` ApiResultModel<String>`
extension ApiResultExt<T extends Object> on ApiResultModel<T> {
  /// 复制当前 ApiResultModel 并可选择性修改字段，可转换泛型
  ///
  /// [code]：状态码，可选
  /// [data]：数据内容，可选，类型为 R。如果未指定 data 且原 data 可转换为 R 类型，则自动转换，否则为 null。
  /// [errorType]：错误类型，可选
  /// [message]：消息，可选
  ApiResultModel<R> copyWith<R extends Object>({
    int? code,
    R? data,
    ApiErrorType? errorType,
    String? message,
  }) {
    return ApiResultModel<R>(
      code: code ?? this.code,
      // 如果未传入 data，且原 data 可以转换为 R，则复用原 data，否则为 null。可进行泛型转换。
      data: data ?? (this.data is R ? this.data as R : null),
      errorType: errorType ?? this.errorType,
      message: message ?? this.message,
    );
  }
}

/// ApiListResultModel 的扩展，用于方便地复制对象并修改部分字段。
///
/// 示例：
/// ```dart
/// // 假设已有 ApiListResultModel<User> result
/// ApiListResultModel<User> copy1 = result.copyWith(message: "列表型新消息");
/// ApiListResultModel<Map<String, dynamic>> copy2 = result.copyWith<Map<String, dynamic>>(data: [{"id": 1}]);
/// ```
/// 上述例子中：
/// - copy1 类型为 `ApiListResultModel<User>`
/// - copy2 类型为 `ApiListResultModel<Map<String, dynamic>>`
extension ApiListResultExt<T extends Object> on ApiListResultModel<T> {
  /// 复制当前 ApiListResultModel 并可选择性修改字段，可转换泛型
  ///
  /// [code]：状态码，可选
  /// [data]：数据内容，为 `List<R>`，可选。如果未指定 data 且原 data 可转换为 `List<R>` 类型，则自动转换，否则为 null。
  /// [errorType]：错误类型，可选
  /// [message]：消息，可选
  ApiListResultModel<R> copyWith<R extends Object>({
    int? code,
    List<R>? data,
    ApiErrorType? errorType,
    String? message,
  }) {
    return ApiListResultModel<R>(
      code: code ?? this.code,
      // 如果未传入 data，且原 data 可以转换为 List<R>，则复用原 data，否则为 null。可进行泛型转换。
      data: data ?? (this.data is List<R> ? this.data as List<R> : null),
      errorType: errorType ?? this.errorType,
      message: message ?? this.message,
    );
  }
}
