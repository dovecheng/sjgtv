import '../../arch/errors/failures.dart';
import '../../arch/errors/result.dart';

/// Use Case 抽象类
///
/// Use Case 是业务逻辑的封装，代表应用程序中的单个用例。
/// 每个 Use Case 应该：
/// - 接收一个输入参数（params）
/// - 返回一个 Result&lt;Output, Failure&gt;
/// - 不包含任何 UI 逻辑
/// - 不直接依赖于 Provider
abstract class UseCase<Params, Output> {
  /// 执行用例
  ///
  /// [params] - 输入参数
  /// 返回 Result&lt;Output, Failure&gt;
  Future<Result<Output, Failure>> call(Params params);
}

/// 无参数 Use Case
///
/// 用于不需要参数的 Use Case
typedef NoParams = void;

/// 简化的 Use Case 基类
///
/// 提供更简单的 UseCase 实现方式，适合简单的业务逻辑。
/// 直接在子类中实现具体的 call 方法，参数由子类决定。
///
/// 示例：
/// ```dart
/// class SearchVideosUseCase extends SimpleUseCase {
///   SearchVideosUseCase(this.repository);
///
///   final VideoRepository repository;
///
///   Future<Result<List<Video>, Failure>> call(
///     String query, {
///     int page = 1,
///     int pageSize = 20,
///   }) async {
///     return repository.searchVideos(query, page: page, pageSize: pageSize);
///   }
/// }
/// ```
abstract class SimpleUseCase {
  /// 执行用例
  ///
  /// 子类应重写此方法，参数由子类决定。
  Future<Result<dynamic, Failure>> call();
}