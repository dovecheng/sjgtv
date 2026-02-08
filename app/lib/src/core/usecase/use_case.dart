import 'package:sjgtv/src/app/errors/failures.dart';
import 'package:sjgtv/src/app/errors/result.dart';

/// Use Case 抽象类
///
/// Use Case 是业务逻辑的封装，代表应用程序中的单个用例。
/// 每个 Use Case 应该：
/// - 接收一个输入参数（params）
/// - 返回一个 Result<Output, Failure>
/// - 不包含任何 UI 逻辑
/// - 不直接依赖于 Provider
abstract class UseCase<Params, Output> {
  /// 执行用例
  ///
  /// [params] - 输入参数
  /// 返回 Result<Output, Failure>
  Future<Result<Output, Failure>> call(Params params);
}

/// 无参数 Use Case
///
/// 用于不需要参数的 Use Case
typedef NoParams = void;