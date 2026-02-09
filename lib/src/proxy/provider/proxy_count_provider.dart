import 'package:sjgtv/core/isar/isar.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:sjgtv/src/proxy/model/proxy_model.dart';

part 'proxy_count_provider.g.dart';

/// 代理数量提供者 [proxyCountStorageProvider]
@Riverpod(keepAlive: true)
class ProxyCountStorageProvider extends _$ProxyCountStorageProvider {
  @override
  Future<int> build() async => $isar.proxies.count();
}
