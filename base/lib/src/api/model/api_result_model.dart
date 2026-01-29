import 'package:base/api.dart';
import 'package:base/converter.dart';
import 'package:base/env.dart';
import 'package:base/log.dart';
import 'package:meta/meta.dart';
import 'package:quiver/core.dart' as quiver;

/// 接口请求结果
///
/// ```dart
/// // 不要解析数据
/// ApiResult
///
/// // 解析单个实体
/// ApiResult<XModel>
///
/// // 手动解析数据
/// ApiResult<Map<String, dynamic>>
/// ```
class ApiResultModel<T extends Object> {
  static const int successfulCode = 200;
  static const int erroredCode = -1;

  @visibleForTesting
  static final Log log = (ApiResultModel).log;

  /// 错误码
  final int code;

  /// 数据
  final T? data;

  /// 错误类型
  final ApiErrorType? errorType;

  /// 消息
  final String? message;

  const ApiResultModel({
    this.code = successfulCode,
    this.data,
    this.errorType,
    this.message,
  });

  const ApiResultModel.success({this.data, this.message})
    : code = successfulCode,
      errorType = null;

  const ApiResultModel.error({
    this.code = erroredCode,
    this.errorType,
    this.message,
  }) : data = null;

  factory ApiResultModel.fromJson(Map<String, dynamic> json) =>
      ApiResultModel._factory(
        json,
        ApiResultModel<T>.new,
        JSONConverter.fromJsonOrNull<T>,
      );

  /// 是否包含数据
  bool get hasData {
    T? it = data;
    if (it != null) {
      if (it is Iterable) {
        return it.isNotEmpty;
      } else if (it is Map) {
        return it.isNotEmpty;
      } else if (it is String) {
        return it.isNotEmpty;
      }
      return true;
    }
    return false;
  }

  /// 是否包含消息
  bool get hasMessage => message?.isNotEmpty == true;

  /// 是否取消请求
  bool get isCancelError => errorType == ApiErrorType.cancel;

  /// 是否请求错误
  bool get isError => errorType != null || code != successfulCode;

  /// 是否请求错误并包含消息
  bool get isErrorAndHasMessage => isError && hasMessage;

  /// 是否请求错误并包含数据
  bool get isErrorAndHasData => isError && hasData;

  /// 是否请求成功
  bool get isSuccess => code == successfulCode && errorType == null;

  /// 是否请求成功并包含数据
  bool get isSuccessAndHasData => isSuccess && hasData;

  /// 是否请求成功并且包含消息
  bool get isSuccessAndHasMessage => isSuccess && hasMessage;

  /// Json序列化
  Map<String, dynamic> toJson() => {
    'code': code,
    'data': JSONConverter.toJsonOrNull(data),
    'errorType': errorType?.name,
    'msg': message,
  };

  @override
  String toString() => JSONConverter.toJsonStringify(toJson());

  /// 数据解析工厂方法
  static T _factory<T extends ApiResultModel>(
    Map<String, dynamic> json,
    Function constructor,
    Function converter,
  ) {
    // 数据解析过程诊断
    ApiMapDiagnosisModel<String, dynamic> node = ApiMapDiagnosisModel(json);
    try {
      int? code = IntConverter.toIntOrNull(node['code']);

      ApiErrorType? errorType = node['errorType'];
      if (code == null) {
        errorType ??= ApiErrorType.unknownError;
      } else if (code != successfulCode) {
        errorType ??= ApiErrorType.badResponse;
      }

      String? message = node['msg'];
      message = message?.trim();
      if (message == null || message.isEmpty) {
        message = errorType?.l10n.value;
      }

      return constructor(
        code: code,
        data: code == null || code == successfulCode
            ? ApiDiagnosisModel.unwrap(converter(node['data']))
            : null,
        errorType: errorType,
        message: message,
      );
    } catch (e, s) {
      // 发生错误的位置
      String diagnosisPath = node.current.path;
      // 请求标识
      String requestId =
          node['requestId'] ?? quiver.hash3(e, s, diagnosisPath).shortHash;
      // 远程日志
      log.e(() => '#$requestId $diagnosisPath', e, s);
      return constructor(
        code: -1,
        errorType: ApiErrorType.parseError,
        message: !kReleaseMode
            ? '${ApiErrorType.parseError.l10n.value}\n#$requestId, $diagnosisPath, ${e.runtimeType}: $e'
            : '${ApiErrorType.parseError.l10n.value}\n#$requestId',
      );
    }
  }
}

/// 接口请求结果(集合)
///
/// ```dart
/// // 解析多个实体
/// ApiListResult<XModel>
///
/// // 手动解析数据
/// ApiListResult<Map<String, dynamic>>
/// ```
class ApiListResultModel<T extends Object> extends ApiResultModel<List<T>> {
  const ApiListResultModel({
    super.code,
    super.data,
    super.errorType,
    super.message,
  });

  const ApiListResultModel.success({super.data, super.message})
    : super.success();

  const ApiListResultModel.error({super.code, super.errorType, super.message})
    : super.error();

  factory ApiListResultModel.fromJson(Map<String, dynamic> json) =>
      ApiResultModel._factory(
        json,
        ApiListResultModel<T>.new,
        JSONConverter.fromJsonArrayOrNull<T>,
      );
}
