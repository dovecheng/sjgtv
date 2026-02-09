import '../../../core/arch/errors/failures.dart';
import '../../../core/arch/errors/result.dart';
import '../entities/proxy.dart';

/// 代理仓库接口
///
/// 定义代理数据的访问方法，不关心具体实现细节
abstract class ProxyRepository {
  /// 获取所有代理
  Future<Result<List<Proxy>, Failure>> getAllProxies();

  /// 获取启用的代理
  Future<Result<List<Proxy>, Failure>> getEnabledProxies();

  /// 添加代理
  ///
  /// [proxy] 代理实体
  Future<Result<Proxy, Failure>> addProxy(Proxy proxy);

  /// 更新代理
  ///
  /// [proxy] 代理实体
  Future<Result<Proxy, Failure>> updateProxy(Proxy proxy);

  /// 删除代理
  ///
  /// [uuid] 代理 UUID
  Future<Result<void, Failure>> deleteProxy(String uuid);

  /// 切换代理启用/禁用状态
  ///
  /// [uuid] 代理 UUID
  Future<Result<Proxy, Failure>> toggleProxy(String uuid);
}