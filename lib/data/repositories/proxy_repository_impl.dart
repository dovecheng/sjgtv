import 'package:sjgtv/core/arch/errors/failures.dart';
import 'package:sjgtv/core/arch/errors/result.dart';
import 'package:sjgtv/domain/entities/proxy.dart';
import 'package:sjgtv/domain/repositories/proxy_repository.dart';
import 'package:sjgtv/data/datasources/local_datasource.dart';

/// 代理仓库实现
///
/// 实现 ProxyRepository 接口，提供代理数据的访问功能
class ProxyRepositoryImpl implements ProxyRepository {
  ProxyRepositoryImpl({required this.localDataSource});

  final LocalDataSource localDataSource;

  @override
  Future<Result<List<Proxy>, Failure>> getAllProxies() async {
    return localDataSource.getAllProxies();
  }

  @override
  Future<Result<List<Proxy>, Failure>> getEnabledProxies() async {
    final result = await getAllProxies();
    if (result.isFailure) {
      return Result.failure(result.error!);
    }

    final proxies = result.value!.where((p) => p.enabled).toList();
    return Result.success(proxies);
  }

  @override
  Future<Result<Proxy, Failure>> addProxy(Proxy proxy) async {
    return localDataSource.addProxy(proxy);
  }

  @override
  Future<Result<Proxy, Failure>> updateProxy(Proxy proxy) async {
    return localDataSource.updateProxy(proxy);
  }

  @override
  Future<Result<void, Failure>> deleteProxy(String uuid) async {
    return localDataSource.deleteProxy(uuid);
  }

  @override
  Future<Result<Proxy, Failure>> toggleProxy(String uuid) async {
    // 获取当前代理
    final proxiesResult = await getAllProxies();
    if (proxiesResult.isFailure) {
      return Result.failure(proxiesResult.error!);
    }

    final proxies = proxiesResult.value!;
    final proxy = proxies.cast<Proxy?>().firstWhere(
      (p) => p?.uuid == uuid,
      orElse: () => null,
    );

    if (proxy == null) {
      return Result.failure(const NotFoundFailure('代理不存在'));
    }

    // 切换状态
    final updated = proxy.copyWith(enabled: !proxy.enabled);
    return updateProxy(updated);
  }
}
